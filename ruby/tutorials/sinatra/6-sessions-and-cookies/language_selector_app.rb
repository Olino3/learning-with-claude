require 'sinatra'
require 'sinatra/reloader' if development?

enable :sessions

# Translation strings
TRANSLATIONS = {
  en: {
    name: 'English',
    flag: '🇬🇧',
    welcome: 'Welcome to our multilingual website!',
    description: 'This demo shows how to use cookies to remember user language preferences.',
    choose_language: 'Choose your language:',
    current_language: 'Current language',
    home: 'Home',
    about: 'About',
    contact: 'Contact',
    features: 'Features',
    feature_1: 'Cookie-based language storage',
    feature_2: 'Persistent across sessions',
    feature_3: 'Easy language switching',
    about_text: 'We are a global company serving customers worldwide.',
    contact_text: 'Get in touch with us in your preferred language.',
    footer: 'Made with Sinatra'
  },
  es: {
    name: 'Español',
    flag: '🇪🇸',
    welcome: '¡Bienvenido a nuestro sitio web multilingüe!',
    description: 'Esta demostración muestra cómo usar cookies para recordar las preferencias de idioma del usuario.',
    choose_language: 'Elige tu idioma:',
    current_language: 'Idioma actual',
    home: 'Inicio',
    about: 'Acerca de',
    contact: 'Contacto',
    features: 'Características',
    feature_1: 'Almacenamiento de idioma basado en cookies',
    feature_2: 'Persistente entre sesiones',
    feature_3: 'Cambio de idioma fácil',
    about_text: 'Somos una empresa global que atiende a clientes en todo el mundo.',
    contact_text: 'Póngase en contacto con nosotros en su idioma preferido.',
    footer: 'Hecho con Sinatra'
  },
  fr: {
    name: 'Français',
    flag: '🇫🇷',
    welcome: 'Bienvenue sur notre site multilingue!',
    description: 'Cette démo montre comment utiliser les cookies pour mémoriser les préférences linguistiques de l\'utilisateur.',
    choose_language: 'Choisissez votre langue:',
    current_language: 'Langue actuelle',
    home: 'Accueil',
    about: 'À propos',
    contact: 'Contact',
    features: 'Fonctionnalités',
    feature_1: 'Stockage de langue basé sur les cookies',
    feature_2: 'Persistant entre les sessions',
    feature_3: 'Changement de langue facile',
    about_text: 'Nous sommes une entreprise mondiale au service de clients du monde entier.',
    contact_text: 'Contactez-nous dans votre langue préférée.',
    footer: 'Fait avec Sinatra'
  },
  de: {
    name: 'Deutsch',
    flag: '🇩🇪',
    welcome: 'Willkommen auf unserer mehrsprachigen Website!',
    description: 'Diese Demo zeigt, wie Cookies verwendet werden, um Benutzerspracheinstellungen zu speichern.',
    choose_language: 'Wählen Sie Ihre Sprache:',
    current_language: 'Aktuelle Sprache',
    home: 'Startseite',
    about: 'Über uns',
    contact: 'Kontakt',
    features: 'Funktionen',
    feature_1: 'Cookie-basierte Sprachspeicherung',
    feature_2: 'Sitzungsübergreifend persistent',
    feature_3: 'Einfacher Sprachwechsel',
    about_text: 'Wir sind ein globales Unternehmen, das Kunden weltweit bedient.',
    contact_text: 'Kontaktieren Sie uns in Ihrer bevorzugten Sprache.',
    footer: 'Erstellt mit Sinatra'
  },
  ja: {
    name: '日本語',
    flag: '🇯🇵',
    welcome: '多言語ウェブサイトへようこそ！',
    description: 'このデモは、ユーザーの言語設定を記憶するためにCookieを使用する方法を示しています。',
    choose_language: '言語を選択:',
    current_language: '現在の言語',
    home: 'ホーム',
    about: '概要',
    contact: 'お問い合わせ',
    features: '特徴',
    feature_1: 'Cookieベースの言語保存',
    feature_2: 'セッション間で永続化',
    feature_3: '簡単な言語切り替え',
    about_text: '世界中のお客様にサービスを提供するグローバル企業です。',
    contact_text: 'お好みの言語でお問い合わせください。',
    footer: 'Sinatraで作成'
  }
}

helpers do
  # Get current language from cookie or default to English
  def current_language
    lang = request.cookies['language']
    lang && TRANSLATIONS.key?(lang.to_sym) ? lang.to_sym : :en
  end

  # Get translation for current language
  def t(key)
    TRANSLATIONS[current_language][key] || key.to_s
  end

  # Get all available languages
  def available_languages
    TRANSLATIONS.keys
  end

  # Get language info
  def language_info(lang)
    TRANSLATIONS[lang]
  end
end

# Set language
post '/language/:lang' do
  lang = params[:lang].to_sym

  if TRANSLATIONS.key?(lang)
    # Set cookie for 1 year
    response.set_cookie('language',
      value: lang.to_s,
      max_age: 365 * 24 * 60 * 60,  # 1 year
      path: '/',
      httponly: true,
      same_site: :lax
    )
  end

  # Redirect back to previous page
  redirect back
end

# Home page
get '/' do
  erb :home
end

# About page
get '/about' do
  erb :about
end

# Contact page
get '/contact' do
  erb :contact
end

__END__

@@layout
<!DOCTYPE html>
<html lang="<%= current_language %>">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= t(:home) %> - Language Selector Demo</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif;
      line-height: 1.6;
      color: #333;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
    }

    header {
      background: rgba(255, 255, 255, 0.95);
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      position: sticky;
      top: 0;
      z-index: 100;
    }

    .header-content {
      max-width: 1200px;
      margin: 0 auto;
      padding: 1rem 2rem;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    nav {
      display: flex;
      gap: 2rem;
      align-items: center;
    }

    nav a {
      color: #667eea;
      text-decoration: none;
      font-weight: 600;
      transition: color 0.2s;
    }

    nav a:hover {
      color: #764ba2;
    }

    .language-selector {
      display: flex;
      gap: 0.5rem;
      align-items: center;
      background: #f8f9fa;
      padding: 0.5rem 1rem;
      border-radius: 25px;
    }

    .language-btn {
      background: none;
      border: none;
      font-size: 1.5rem;
      cursor: pointer;
      transition: transform 0.2s;
      padding: 0.25rem;
    }

    .language-btn:hover {
      transform: scale(1.2);
    }

    .language-btn.active {
      transform: scale(1.3);
    }

    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 3rem 2rem;
    }

    .hero {
      background: white;
      border-radius: 15px;
      padding: 3rem;
      text-align: center;
      box-shadow: 0 10px 40px rgba(0,0,0,0.1);
      margin-bottom: 2rem;
    }

    .hero h1 {
      color: #667eea;
      font-size: 2.5rem;
      margin-bottom: 1rem;
    }

    .hero p {
      font-size: 1.25rem;
      color: #666;
      max-width: 700px;
      margin: 0 auto;
    }

    .current-lang {
      display: inline-block;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 0.75rem 1.5rem;
      border-radius: 25px;
      margin: 2rem 0;
      font-weight: 600;
    }

    .features {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 2rem;
      margin-top: 2rem;
    }

    .feature-card {
      background: white;
      padding: 2rem;
      border-radius: 15px;
      box-shadow: 0 10px 40px rgba(0,0,0,0.1);
      text-align: center;
    }

    .feature-card h3 {
      color: #667eea;
      margin-bottom: 1rem;
    }

    .content-box {
      background: white;
      padding: 3rem;
      border-radius: 15px;
      box-shadow: 0 10px 40px rgba(0,0,0,0.1);
    }

    .content-box h2 {
      color: #667eea;
      margin-bottom: 1.5rem;
    }

    .content-box p {
      font-size: 1.1rem;
      color: #555;
      line-height: 1.8;
    }

    footer {
      text-align: center;
      padding: 2rem;
      color: white;
      margin-top: 2rem;
    }

    .language-picker {
      background: white;
      padding: 2rem;
      border-radius: 15px;
      box-shadow: 0 10px 40px rgba(0,0,0,0.1);
      margin-bottom: 2rem;
    }

    .language-picker h3 {
      color: #667eea;
      margin-bottom: 1.5rem;
      text-align: center;
    }

    .language-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 1rem;
    }

    .language-option {
      border: 2px solid #e0e0e0;
      padding: 1rem;
      border-radius: 10px;
      text-align: center;
      cursor: pointer;
      transition: all 0.2s;
      background: none;
      width: 100%;
      font-size: 1rem;
    }

    .language-option:hover {
      border-color: #667eea;
      transform: translateY(-2px);
    }

    .language-option.active {
      border-color: #667eea;
      background: #667eea;
      color: white;
    }

    .language-flag {
      font-size: 2rem;
      display: block;
      margin-bottom: 0.5rem;
    }
  </style>
</head>
<body>
  <header>
    <div class="header-content">
      <div style="font-size: 1.5rem; font-weight: bold; color: #667eea;">
        🌍 MultiLang
      </div>

      <nav>
        <a href="/"><%= t(:home) %></a>
        <a href="/about"><%= t(:about) %></a>
        <a href="/contact"><%= t(:contact) %></a>

        <div class="language-selector">
          <% available_languages.each do |lang| %>
            <form action="/language/<%= lang %>" method="post" style="display: inline;">
              <button type="submit" class="language-btn <%= 'active' if lang == current_language %>" title="<%= language_info(lang)[:name] %>">
                <%= language_info(lang)[:flag] %>
              </button>
            </form>
          <% end %>
        </div>
      </nav>
    </div>
  </header>

  <div class="container">
    <%= yield %>
  </div>

  <footer>
    <%= t(:footer) %> • <%= Time.now.year %>
  </footer>
</body>
</html>

@@home
<div class="hero">
  <h1><%= t(:welcome) %></h1>
  <p><%= t(:description) %></p>

  <div class="current-lang">
    <%= language_info(current_language)[:flag] %>
    <%= t(:current_language) %>: <%= language_info(current_language)[:name] %>
  </div>
</div>

<div class="language-picker">
  <h3><%= t(:choose_language) %></h3>
  <div class="language-grid">
    <% available_languages.each do |lang| %>
      <form action="/language/<%= lang %>" method="post">
        <button type="submit" class="language-option <%= 'active' if lang == current_language %>">
          <span class="language-flag"><%= language_info(lang)[:flag] %></span>
          <%= language_info(lang)[:name] %>
        </button>
      </form>
    <% end %>
  </div>
</div>

<h2 style="color: white; text-align: center; margin-bottom: 1.5rem;">
  <%= t(:features) %>
</h2>

<div class="features">
  <div class="feature-card">
    <h3>🍪</h3>
    <p><%= t(:feature_1) %></p>
  </div>

  <div class="feature-card">
    <h3>💾</h3>
    <p><%= t(:feature_2) %></p>
  </div>

  <div class="feature-card">
    <h3>🔄</h3>
    <p><%= t(:feature_3) %></p>
  </div>
</div>

@@about
<div class="content-box">
  <h2><%= t(:about) %></h2>
  <p><%= t(:about_text) %></p>

  <h3 style="margin-top: 2rem; margin-bottom: 1rem; color: #667eea;">
    Available Languages
  </h3>
  <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
    <% available_languages.each do |lang| %>
      <div style="background: #f8f9fa; padding: 1rem; border-radius: 10px;">
        <span style="font-size: 2rem;"><%= language_info(lang)[:flag] %></span>
        <div><strong><%= language_info(lang)[:name] %></strong></div>
      </div>
    <% end %>
  </div>
</div>

@@contact
<div class="content-box">
  <h2><%= t(:contact) %></h2>
  <p><%= t(:contact_text) %></p>

  <div style="margin-top: 2rem; padding: 2rem; background: #f8f9fa; border-radius: 10px;">
    <h3 style="color: #667eea; margin-bottom: 1rem;">
      Cookie Information
    </h3>
    <p style="margin-bottom: 0.5rem;">
      <strong>Language Cookie:</strong>
      <%= request.cookies['language'] || 'Not set (using default)' %>
    </p>
    <p style="margin-bottom: 0.5rem;">
      <strong>Current Language:</strong>
      <%= language_info(current_language)[:name] %>
    </p>
    <p style="color: #666; font-size: 0.875rem; margin-top: 1rem;">
      Your language preference is stored in a cookie that lasts for 1 year.
      This allows the website to remember your preferred language across visits.
    </p>
  </div>
</div>
