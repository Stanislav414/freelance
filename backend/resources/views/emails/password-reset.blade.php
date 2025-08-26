<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Восстановление пароля - SuriTask</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            color: #333;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #ffffff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 28px;
            font-weight: 700;
        }
        .content {
            padding: 40px 30px;
        }
        .code-container {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 30px;
            border-radius: 12px;
            text-align: center;
            margin: 30px 0;
        }
        .code {
            font-size: 48px;
            font-weight: 700;
            letter-spacing: 8px;
            margin: 20px 0;
            font-family: 'Courier New', monospace;
        }
        .info {
            background-color: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 20px;
            margin: 30px 0;
            border-radius: 0 8px 8px 0;
        }
        .footer {
            background-color: #f8f9fa;
            padding: 30px;
            text-align: center;
            color: #6c757d;
            font-size: 14px;
        }
        .button {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            padding: 15px 30px;
            border-radius: 8px;
            font-weight: 600;
            margin: 20px 0;
        }
        .warning {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🔐 Восстановление пароля</h1>
            <p>SuriTask — умная фриланс платформа</p>
        </div>
        
        <div class="content">
            <h2>Здравствуйте!</h2>
            <p>Мы получили запрос на восстановление пароля для вашего аккаунта SuriTask.</p>
            
            <div class="code-container">
                <h3>Ваш код восстановления:</h3>
                <div class="code">{{ $code }}</div>
                <p>Введите этот код в форму восстановления пароля</p>
            </div>
            
            <div class="warning">
                <strong>⚠️ Важно:</strong> Код действителен только 10 минут. Если вы не запрашивали восстановление пароля, просто проигнорируйте это письмо.
            </div>
            
            <div class="info">
                <h4>Как использовать код:</h4>
                <ol>
                    <li>Вернитесь на страницу восстановления пароля</li>
                    <li>Введите полученный код в поле "Код подтверждения"</li>
                    <li>Придумайте новый надежный пароль</li>
                    <li>Нажмите "Сменить пароль"</li>
                </ol>
            </div>
            
            <p>Если у вас возникли проблемы, обратитесь в <a href="mailto:suritask.help@gmail.com">техподдержку</a>.</p>
        </div>
        
        <div class="footer">
            <p>С уважением, команда SuriTask</p>
            <p>Это автоматическое письмо, не отвечайте на него</p>
            <p>© 2025 SuriTask. Все права защищены.</p>
        </div>
    </div>
</body>
</html>
