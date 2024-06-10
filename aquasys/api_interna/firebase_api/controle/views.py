from django.http import JsonResponse
from rest_framework.response import Response 
from rest_framework.decorators import api_view
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.hashers import check_password
from django.core.mail import send_mail
from random import randrange
import re
from django.shortcuts import render
from firebase_api.firebase_config import db
from django.core.mail import EmailMultiAlternatives

@api_view(['POST'])
def cadastra_usuario(request):
    try:
        info = request.data
        email = info.get('email')
            
        if not email:
            return JsonResponse({'mensagem': 'Todos os campos são obrigatórios'}, status=400)
        
        users_ref = db.collection('users')
        query = users_ref.where('Email', '==', email).stream()
        email_cadastrado = any(query)

        if email_cadastrado:
            return JsonResponse({'mensagem': 'Este email já está cadastrado'}, status=200)
        else:
            # Cadastra o novo usuário
            doc_ref = users_ref.document()
            doc_ref.set({
                'Email': email,
                'Administrador': False
            })
            return JsonResponse({'mensagem': 'Usuário cadastrado com sucesso'}, status=201)

    except Exception as e:
        return JsonResponse({'mensagem': f'Erro ao cadastrar usuário: {str(e)}'}, status=500)

@api_view(['POST'])
def verifica_cadastro(request):
    try:
        info = request.data
        email = info.get('email')
        
        if not email:
            return JsonResponse({'mensagem': 'Todos os campos são obrigatórios', 'email_cadastrado': False}, status=400)
        
        users_ref = db.collection('users')
        query = users_ref.where('Email', '==', email).stream()
        email_cadastrado = any(query)
        
        if email_cadastrado:
            return JsonResponse({'mensagem': 'Este email tem acesso'}, status=200)
        else:
            return JsonResponse({'mensagem': 'Este email não está cadastrado'}, status=403)

    except Exception as e:
        return JsonResponse({'mensagem': f'Erro ao cadastrar usuário: {str(e)}', 'email_cadastrado': False}, status=500)

@api_view(['POST'])
def verifica_adm(request):
    try:
        info = request.data
        email = info.get('email')
        
        if not email:
            return JsonResponse({'mensagem': 'Todos os campos são obrigatórios', 'email_cadastrado': False, 'administrador': False}, status=400)
        
        users_ref = db.collection('users')
        query = users_ref.where('Email', '==', email).stream()
        user_data = next(query, None)
        
        if user_data:
            user_dict = user_data.to_dict()
            is_admin = user_dict.get('Administrador', False)
            return JsonResponse({'mensagem': 'Este email tem acesso', 'email_cadastrado': True, 'administrador': is_admin}, status=200)
        else:
            return JsonResponse({'mensagem': 'Este email não está cadastrado', 'email_cadastrado': False, 'administrador': False}, status=200)

    except Exception as e:
        return JsonResponse({'mensagem': f'Erro ao verificar usuário: {str(e)}', 'email_cadastrado': False, 'administrador': False}, status=500)
   
@api_view(['POST'])
def altera_adm(request):
    try:
        info = request.data
        email = info.get('email') 
        if not email:
            return JsonResponse({'mensagem': 'Todos os campos são obrigatórios'}, status=400)

        doc_ref = db.collection('users')
        query = doc_ref.where('Email', '==', email).get()

        for doc in query:
            user_data = doc.to_dict()
            if user_data.get('Administrador', False):
                return JsonResponse({'mensagem': 'Usuário já é administrador'}, status=201)

            doc_ref.document(doc.id).update({'Administrador': True})
            return JsonResponse({'mensagem': 'Usuário atualizado com sucesso'}, status=200)

        return JsonResponse({'mensagem': 'Usuário não encontrado'}, status=404)

    except Exception as e:
        return JsonResponse({'mensagem': f'Erro ao atualizar usuário: {str(e)}'}, status=500)  

@api_view(['POST'])
def envia_email(request):
    info = request.data
    data = info.get('data')
    horario = info.get('horario')
    if not data or not horario:
        return JsonResponse({'mensagem': 'Todos os campos são obrigatórios'}, status=400)
    try:
        subject = "Aviso de Manutenção Programada na Bomba de Água"
        from_email = 'aquasys.avisos@gmail.com'
        to_email = ['pivisoto10@gmail.com']

        html_content = f"""
        <!DOCTYPE html>
        <html lang="pt-BR">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Aviso de Manutenção Programada na Bomba de Água</title>
            <style>
                body {{
                    font-family: Arial, sans-serif;
                    max-width: 600px;
                    margin: 0 auto;
                    line-height: 1.6;
                    color: #333;
                }}
                h1 {{
                    color: #007bff;
                }}
                ul {{
                    list-style-type: none;
                    padding: 0;
                }}
                li {{
                    margin-bottom: 10px;
                }}
                .blue-text {{
                    color: #007bff;
                }}
                .black-text {{
                    color: #000;
                }}
            </style>
        </head>
        <body>
            <h1>Aviso de Manutenção Programada na Bomba de Água</h1>
            <p class="black-text">Prezado(a),</p>
            <p class="black-text">Informamos que a bomba de água do Instituto Mauá Tecnologia passará por uma manutenção programada nos seguintes horários:</p>
            <ul>
                <li><span class="blue-text"><strong>Data:</strong></span> <span class="black-text">{data}</span></li>
                <li><span class="blue-text"><strong>Horário:</strong></span> <span class="black-text">Das {horario}</span></li>
            </ul>
            <p class="black-text">Pedimos desculpas por qualquer inconveniente que esta manutenção possa causar e agradecemos pela sua compreensão. Nosso objetivo é garantir que todos os equipamentos estejam funcionando corretamente para evitar problemas futuros e melhorar a eficiência dos nossos serviços.</p>
            <p class="black-text">Caso tenha alguma dúvida ou precise de mais informações, por favor, entre em contato conosco pelo e-mail.</p>
            <p class="black-text">Agradecemos pela atenção.</p>
            <p class="black-text">Atenciosamente,<br>GMS</p>
        </body>
        </html>
        """
        msg = EmailMultiAlternatives(subject, 'Corpo do email em texto simples', from_email, to_email)
        msg.attach_alternative(html_content, "text/html")
        msg.send()
        return JsonResponse({'mensagem': 'Email enviado com sucesso'}, status=200)
    except Exception as e:
        return JsonResponse({'mensagem': f'Erro ao enviar email: {str(e)}'}, status=500)