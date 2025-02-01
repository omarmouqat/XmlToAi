from django.urls import path
from . import views

urlpatterns = [
    path('', views.editor_view, name='editor'),
    path('download/<str:filename>/', views.download_file_response, name='download'),
    path('upload/', views.upload_file, name='upload'),
    path('transform/', views.transform_file, name='transform'),
    path('download/', views.download_python_code_response, name='download_python'),
    path('tutorial/', views.tutorial, name='tutorial'),
    path('execute/', views.execute, name='execute'),
    path('execute/script', views.execute_script, name='execute_script'),
    path('ContactUs/', views.contact_us, name='contact_us'),
    path('ContactUs/send_email', views.send_email, name='send_email'),

]

