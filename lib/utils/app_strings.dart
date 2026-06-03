/// Файл со всеми строками приложения для локализации
/// Использование: AppStrings.get('home_title')
class AppStrings {
  // Текущий язык (по умолчанию русский)
  static String _currentLang = 'ru';

  // Переключение языка
  static void setLanguage(String lang) {
    if (lang == 'en' || lang == 'ru') {
      _currentLang = lang;
    }
  }

  static String get currentLang => _currentLang;

  // Получить строку по ключу
  static String get(String key) {
    final map = _currentLang == 'en' ? _en : _ru;
    return map[key] ?? _ru[key] ?? key;
  }

  // ========== РУССКИЙ ==========
  static const Map<String, String> _ru = {
    // --- Общие ---
    'app_name': 'SkillMe',
    'loading': 'Загрузка...',
    'error': 'Ошибка',
    'retry': 'Повторить',
    'cancel': 'Отмена',
    'ok': 'ОК',
    'save': 'Сохранить',
    'delete': 'Удалить',
    'edit': 'Редактировать',
    'close': 'Закрыть',
    'back': 'Назад',
    'next': 'Далее',
    'yes': 'Да',
    'no': 'Нет',
    'search': 'Поиск',
    'no_connection': 'Нет соединения',
    'unknown_error': 'Неизвестная ошибка',

    // --- Навигация (нижняя панель) ---
    'nav_home': 'Главная',
    'nav_categories': 'Категории',
    'nav_favorites': 'Избранное',
    'nav_account': 'Аккаунт',

    // --- Главная страница ---
    'home_title': 'Главная',
    'home_popular': 'Популярное',
    'home_new': 'Новое',
    'home_for_you': 'Для вас',
    'home_recommended': 'Рекомендуем',
    'home_welcome': 'Добро пожаловать!',
    'home_watch_more': 'Смотреть больше',

    // --- Регистрация ---
'signup_passwords_not_match': 'Пароли должны совпадать',
'signup_email_in_use': 'Такой Email уже используется',
'repeat_password_hint': 'Повторите пароль',
'already_have_account_login': 'Уже есть аккаунт? Войти',

    // --- Категории ---
    'categories_title': 'Категории',
    'categories_empty': 'Категории не найдены',
    'category_cooking': 'Кулинария',
    'category_science': 'Наука',
    'category_sport': 'Спорт',
    'category_business': 'Бизнес',
    'category_music': 'Музыка', 
    'category_education': 'Образование', 
    'category_games': 'Игры',           
    'category_design': 'Дизайн',  

    // --- Видео ---
    'video_loading': 'Загрузка видео...',
    'video_first_time': 'Первый раз дольше',
    'video_next_time': 'Дальше будет мгновенно!',
    'video_error': 'Ошибка загрузки видео',
    'video_no_title': 'Без названия',
    'video_duration': 'Длительность: {seconds} сек',
    'video_empty': 'Видео пока нет',
    'video_buffering': 'Буферизация...',

    // --- Вход ---
'login_error_invalid': 'Неправильный email или пароль. Повторите попытку',
'login_error_unknown': 'Неизвестная ошибка! Попробуйте еще раз.',
'email_invalid': 'Введите корректный Email',
'email_hint': 'Введите Email',
'password_hint': 'Введите пароль',
'no_account_register': 'Еще нет аккаунта? Регистрация',

// --- Сброс пароля ---
'reset_password_title': 'Сброс пароля',
'reset_email_not_found': 'Такой email не зарегистрирован!',
'reset_error_generic': 'Ошибка! Попробуйте снова.',
'reset_email_sent': 'Ссылка для сброса отправлена на почту',

    // --- Избранное ---
    'favorites_title': 'Избранное',
    'favorites_add': 'В избранное',
    'favorites_added': 'В избранном',
    'favorites_empty': 'У вас пока нет избранных видео',
    'favorites_login_required': 'Войдите, чтобы добавить в избранное',

    // --- Аккаунт ---
    'account_title': 'Аккаунт',
    'account_login': 'Войти',
    'account_logout': 'Выйти',
    'account_register': 'Регистрация',
    'account_profile': 'Профиль',
    'account_settings': 'Настройки',
    'account_edit_profile': 'Редактировать профиль',
    'account_email': 'Email',
    'account_password': 'Пароль',
    'account_name': 'Имя',
    'account_nickname': 'Никнейм',
    'account_unknown': 'Неизвестно',
    'account_change_password': 'Изменить пароль',
    'account_forgot_password': 'Забыли пароль?',
    'account_reset_password': 'Сбросить пароль',

    // --- Верификация email ---
'email_verification_title': 'Верификация Email адреса',
'email_verification_message': 'Письмо с подтверждением было отправлено на вашу электронную почту.',
'resend_email': 'Повторно отправить',

    // --- Настройки ---
    'settings_title': 'Настройки',
    'settings_language': 'Язык',
    'settings_theme': 'Тема',
    'settings_theme_light': 'Светлая',
    'settings_theme_dark': 'Тёмная',
    'settings_theme_system': 'Системная',
    'settings_notifications': 'Уведомления',
    'settings_about': 'О приложении',
    'settings_version': 'Версия',
    'settings_section_profile': 'Профиль',
    'settings_section_app': 'Приложение',
    'settings_section_account': 'Аккаунт',
    'settings_disable_notifications': 'Отключить уведомления',
    'settings_disable_notifications_confirm': 'Вы действительно хотите отписаться от уведомлений?',
    'settings_enter_password': 'Введите пароль',
    'settings_password_hint': 'Пароль',
    'settings_wrong_password': 'Неверный пароль',
    'settings_delete_account': 'Удалить аккаунт',
    'settings_confirm_delete': 'Подтвердите удаление',
    'settings_delete_warning': 'Вы уверены, что хотите удалить аккаунт? Это действие нельзя отменить.',
    'settings_delete_error': 'Ошибка при удалении аккаунта',
    'settings_choose_language': 'Выберите язык',
    'language_russian': 'Русский',
    'language_english': 'English',

    // --- Авторизация ---
    'auth_welcome': 'Добро пожаловать',
    'auth_login_subtitle': 'Войдите в свой аккаунт',
    'auth_register_subtitle': 'Создайте новый аккаунт',
    'auth_already_have_account': 'Уже есть аккаунт?',
    'auth_no_account': 'Нет аккаунта?',
    'auth_sign_up': 'Зарегистрироваться',
    'auth_sign_in': 'Войти',
    'welcome_title': 'Добро \nпожаловать!', 
    'auth_register': 'Регистрация', 

    // --- Сообщения ---
    'msg_success': 'Успешно',
    'msg_failed': 'Не удалось',
    'msg_field_required': 'Это поле обязательно',
    'msg_invalid_email': 'Неверный email',
    'error_refresh': 'Ошибка при обновлении',  
    'search_no_results': 'Ничего не найдено',
    'msg_password_short': 'Пароль слишком короткий',
    'msg_passwords_not_match': 'Пароли не совпадают',
    'msg_account_created': 'Аккаунт создан',
    'msg_logged_in': 'Вы вошли в систему',
    'msg_logged_out': 'Вы вышли из системы',
    'msg_profile_updated': 'Профиль обновлён',

    'change_password_title': 'Изменить пароль',
    'old_password': 'Старый пароль',
    'new_password': 'Новый пароль',
    'confirm_password': 'Подтвердите пароль',
    'password_changed': 'Пароль успешно изменён',
    'wrong_old_password': 'Неверный старый пароль',
    'password_min_length': 'Минимум 6 символов',
    'password_min_length_full': 'Пароль должен быть минимум 6 символов',
    'error_try_again': 'Попробуйте снова',
    'error_try_later': 'Ошибка: попробуйте позже',
  };

  // ========== ENGLISH ==========
  static const Map<String, String> _en = {
    // --- Common ---
    'app_name': 'SkillMe',
    'loading': 'Loading...',
    'error': 'Error',
    'retry': 'Retry',
    'cancel': 'Cancel',
    'ok': 'OK',
    'save': 'Save',
    'delete': 'Delete',
    'edit': 'Edit',
    'close': 'Close',
    'back': 'Back',
    'next': 'Next',
    'yes': 'Yes',
    'no': 'No',
    'search': 'Search',
    'no_connection': 'No connection',
    'unknown_error': 'Unknown error',

    // --- Navigation (bottom bar) ---
    'nav_home': 'Home',
    'nav_categories': 'Categories',
    'nav_favorites': 'Favorites',
    'nav_account': 'Account',

    // --- Home page ---
    'home_title': 'Home',
    'home_popular': 'Popular',
    'home_new': 'New',
    'home_recommended': 'Recommended',
    'home_welcome': 'Welcome!',
    'home_for_you': 'For you',
    'home_watch_more': 'Watch more',

// --- Email verification ---
'email_verification_title': 'Email Verification',
'email_verification_message': 'A confirmation email has been sent to your email address.',
'resend_email': 'Resend',

    // --- Categories ---
    'categories_title': 'Categories',
    'categories_empty': 'No categories found',
    'category_cooking': 'Cooking',
    'category_science': 'Science',
    'category_sport': 'Sport',
    'category_music': 'Music',            
    'category_education': 'Education',  
    'category_games': 'Games',         
    'category_design': 'Design', 
    'category_business': 'Business',

    // --- Video ---
    'video_loading': 'Loading video...',
    'video_first_time': 'First time takes longer',
    'video_next_time': 'Next time it will be instant!',
    'video_error': 'Video loading error',
    'video_no_title': 'No title',
    'video_duration': 'Duration: {seconds} sec',
    'video_empty': 'No videos yet',
    'video_buffering': 'Buffering...',

    // --- Favorites ---
    'favorites_title': 'Favorites',
    'favorites_add': 'Add to favorites',
    'favorites_added': 'In favorites',
    'favorites_empty': 'You have no favorite videos yet',
    'favorites_login_required': 'Log in to add to favorites',

    // --- Account ---
    'account_title': 'Account',
    'account_login': 'Log in',
    'account_logout': 'Log out',
    'account_register': 'Register',
    'account_profile': 'Profile',
    'account_settings': 'Settings',
    'account_unknown': 'Unknown',
    'account_edit_profile': 'Edit profile',
    'account_email': 'Email',
    'account_password': 'Password',
    'account_name': 'Name',
    'account_nickname': 'Nickname',
    'account_change_password': 'Change password',
    'account_forgot_password': 'Forgot password?',
    'account_reset_password': 'Reset password',

    // --- Settings ---
    'settings_title': 'Settings',
    'settings_language': 'Language',
    'settings_theme': 'Theme',
    'settings_theme_light': 'Light',
    'settings_theme_dark': 'Dark',
    'settings_theme_system': 'System',
    'settings_notifications': 'Notifications',
    'settings_about': 'About',
    'settings_version': 'Version',
    'settings_section_profile': 'Profile',
  'settings_section_app': 'Application',
  'settings_section_account': 'Account',
  'settings_disable_notifications': 'Disable notifications',
  'settings_disable_notifications_confirm': 'Do you really want to unsubscribe from notifications?',
  'settings_enter_password': 'Enter password',
  'settings_password_hint': 'Password',
  'settings_wrong_password': 'Wrong password',
  'settings_delete_account': 'Delete account',
  'settings_confirm_delete': 'Confirm deletion',
  'settings_delete_warning': 'Are you sure you want to delete your account? This action cannot be undone.',
  'settings_delete_error': 'Error deleting account',
  'settings_choose_language': 'Choose language',
  'language_russian': 'Russian',
  'language_english': 'English',

    // --- Auth ---
    'auth_welcome': 'Welcome',
    'auth_login_subtitle': 'Log in to your account',
    'auth_register_subtitle': 'Create a new account',
    'auth_already_have_account': 'Already have an account?',
    'auth_no_account': "Don't have an account?",
    'auth_sign_up': 'Sign up',
    'auth_sign_in': 'Sign in',
    'welcome_title': 'Welcome!',           
    'auth_register': 'Register', 

    // --- Messages ---
    'msg_success': 'Success',
    'msg_failed': 'Failed',
    'msg_field_required': 'This field is required',
    'msg_invalid_email': 'Invalid email',
    'msg_password_short': 'Password is too short',
    'msg_passwords_not_match': 'Passwords do not match',
    'error_refresh': 'Error refreshing',     
    'search_no_results': 'Nothing found',
    'msg_account_created': 'Account created',
    'msg_logged_in': 'You are logged in',
    'msg_logged_out': 'You are logged out',
    'msg_profile_updated': 'Profile updated',

    // --- Change password ---
'change_password_title': 'Change password',
'old_password': 'Old password',
'new_password': 'New password',
'confirm_password': 'Confirm password',
'password_changed': 'Password changed successfully',
'wrong_old_password': 'Wrong old password',
'password_min_length': 'Minimum 6 characters',
'password_min_length_full': 'Password must be at least 6 characters',
'error_try_again': 'Try again',
'error_try_later': 'Error: try again later',
  };
}