import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// Заголовки для корректной работы
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Обработка CORS запросов
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // 1. Получаем ссылку со стока из Flutter
    const { stockUrl, fileName } = await req.json()
    if (!stockUrl) throw new Error('URL не предоставлен')

    // 2. Инициализируем клиент Supabase с правами админа (Service Role)
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // 3. Скачиваем видео прямо на сервере Supabase
    const response = await fetch(stockUrl)
    if (!response.ok) throw new Error('Не удалось скачать видео по ссылке')
    
    const videoBlob = await response.blob()

    // 4. Формируем имя файла
    const extension = stockUrl.split('.').pop()?.split('?')[0] || 'mp4'
    const finalFileName = fileName || `video_${Date.now()}.${extension}`

    // 5. Загружаем в бакет 'lesson-videos' (УБЕДИСЬ, ЧТО ОН СОЗДАН В SUPABASE!)
    const { data, error } = await supabaseAdmin.storage
      .from('lesson-videos')
      .upload(finalFileName, videoBlob, {
        contentType: response.headers.get('content-type') || 'video/mp4',
        upsert: false
      })

    if (error) throw error

    // 6. Получаем публичную ссылку
    const { data: urlData } = supabaseAdmin.storage
      .from('lesson-videos')
      .getPublicUrl(finalFileName)

    return new Response(
      JSON.stringify({ success: true, url: urlData.publicUrl }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    )
  }
})