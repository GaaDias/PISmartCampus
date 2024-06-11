from django.contrib import admin
from django.urls import path , include
from controle import views
from django.contrib import admin
from django.urls import path

urlpatterns = [
    path('admin/', admin.site.urls),
    path('cadastra_usuario/',views.cadastra_usuario),
    path('envia_email/',views.envia_email),
    path('altera_adm/',views.altera_adm),
    path('verifica_cadastro/',views.verifica_cadastro),
    path('verifica_adm/',views.verifica_adm),
    path('envia_alerta/',views.envia_alerta)
]
