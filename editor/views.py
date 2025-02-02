"""import os
from django.conf import settings
from django.http import HttpResponse
from django.shortcuts import render
from django.core.files.storage import FileSystemStorage
from .forms import TextEditorForm

def editor_view(request):
    form = TextEditorForm()
    filename = None
    options = None
    text = None
    if request.method == 'POST':
        if 'file' in request.FILES:
            file = request.FILES['file']
            fs = FileSystemStorage(location=os.path.join(settings.MEDIA_ROOT, 'uploads'))
            filename = fs.save(file.name, file)
            file_path = fs.path(filename)


            with open(file_path, 'r') as f:
                content = f.read()

            form = TextEditorForm(initial={'text': content})

        elif 'text' in request.POST and 'filename' in request.POST:
            filename = request.POST['filename']
            print(filename)
            content = request.POST['text']
            file_path = os.path.join(settings.MEDIA_ROOT, 'uploads', filename)

            with open(file_path, 'w') as f:
                f.write(str(content))

            return download_file_response(file_path, filename)

        options = request.POST['options']
        text = request.POST['text']
    return render(request, 'editor.html', {'form': form, 'filename': filename, 'options': options, 'text': text})

def download_file_response(file_path, filename):
    with open(file_path, 'r') as f:
        response = HttpResponse(f.read(), content_type='application/text')
        response['Content-Disposition'] = f'attachment; filename={filename}'
        return response
"""
import os
from dbm import error
from fileinput import filename
from io import StringIO

from django.conf import settings
from django.http import HttpResponse
from django.shortcuts import render
from django.core.files.storage import FileSystemStorage
from lxml.html.defs import safe_attrs

from myproject.settings import MEDIA_ROOT
from .forms import TextEditorForm
from lxml import etree
from django.http import HttpResponse

from dotenv import load_dotenv, dotenv_values

import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart


load_dotenv()

content = ""
path_to_train_data = ""
train_data = ""
def editor_view(request):
    form = None
    filename = None
    options = None
    text = None
    if request.method == 'POST':
        if 'file' in request.FILES:
            file = request.FILES['file']
            fs = FileSystemStorage(location=os.path.join(settings.MEDIA_ROOT, 'uploads'))
            filename = fs.save(file.name, file)
            file_path = fs.path(filename)


            with open(file_path, 'r') as f:
                content = f.read()

            form = TextEditorForm(initial={'text': content})

        elif 'text' in request.POST and 'filename' in request.POST:
            filename = request.POST['filename']
            print(filename)
            content = request.POST['text']
            file_path = os.path.join(settings.MEDIA_ROOT, 'uploads', filename)

            with open(file_path, 'w') as f:
                f.write(str(content))

            return download_file_response(file_path, filename)

        #options = request.POST['options']
        form = request.POST['editor']
    return render(request, 'editor.html', {'form': form, 'filename': filename, 'options': options, 'text': text})

def download_file_response(file_path, filename):
    with open(file_path, 'r') as f:
        response = HttpResponse(f.read(), content_type='application/text')
        response['Content-Disposition'] = f'attachment; filename={filename}'
        return response

def download_python_code_response(request):
    code = None
    file_name = None
    if request.method == 'POST':
        code = request.POST['output']
        file_name = request.POST['file_name']
        print(code)
        print(file_name)
        if file_name == "":
            file_name = "script"
    ## Create the response with the Python code as content
    response = HttpResponse(code, content_type='application/octet-stream')

    # Set the content disposition to force the browser to download the file
    response['Content-Disposition'] = f'attachment; filename={file_name}.py'

    return response


def upload_file(request):
    if request.method == 'POST':
        if 'file' in request.FILES:
            file = request.FILES['file']
            fs = FileSystemStorage(location=os.path.join(settings.MEDIA_ROOT, 'uploads'))
            filename = fs.save(file.name, file)
            file_path = fs.path(filename)

            with open(file_path, 'r') as f:
                content = f.read()
            os.remove(file_path)
    return render(request, 'editor.html', {'content': content})


def transform_file(request):
    out_put = None
    input_code = None
    errors = None
    checkers_rel_path = None
    files_path = os.path.join(settings.MEDIA_ROOT, 'checking_files/')
    if request.method == 'POST':
        input_code = request.POST['code']
        option = request.POST['options']
        if input_code and option :
            if input_code == '':
                return render(request, 'editor.html', {'output': '', 'content': input_code})
            else:
                match option:
                    case 'LR-TF':
                        checkers_rel_path = 'tensorflow/linearRegression/'
                    case 'IC-TF':
                        checkers_rel_path = 'tensorflow/imagesClassification/'
                    case 'LR-PT':
                        checkers_rel_path = 'pytorche/linearRegression/'
                    case 'IC-PT':
                        checkers_rel_path = 'pytorche/imagesClassification/'

                #if option == 'LR-TF':
                #xml = etree.fromstring(input_code)
                with (open
                    (os.path.join(files_path ,(checkers_rel_path+'translator.xsd')), 'r')
                      as schema_file):
                    schema_root = etree.parse(schema_file)
                schema = etree.XMLSchema(schema_root)
                # Charger le fichier XSLT
                with (open
                    (os.path.join(files_path ,(checkers_rel_path+'translator.xslt')), 'r')
                      as xslt_file):
                    xslt_root = etree.parse(xslt_file)
                try:
                    xml_root = etree.fromstring(input_code.encode('utf-8'))

                    is_valid = schema.validate(xml_root)

                    if is_valid:
                        transform = etree.XSLT(xslt_root)
                        out_put = transform(xml_root)
                    else:
                        print("not valid:")
                        log = schema.error_log
                        print(str(log))
                        errors = ""
                        for error in log:
                            errors += "Ligne " + str(error.line) + " : " + str(error.message) + "\n"
                except Exception as e:
                    print("error")
                    errors = e
    return render(request, 'editor.html', {'content': input_code, 'output': out_put, 'errors': errors})


def tutorial(request):

    return render(request, 'tutorials.html')

def execute(request):
    
    return render(request, 'execute.html')

def execute_script(request):
    global content, path_to_train_data, train_data, ml_script_content, train_data_content
    if request.method == 'POST':
        #fs = FileSystemStorage(location=os.path.join(settings.MEDIA_ROOT, 'uploads'))

        ml_script_content = request.POST['ml_script_content_for_training']
        train_data_content = request.POST['train_data_content_for_training']
        """
        ml_script = request.FILES['ml_script']
        ml_script_file_name = fs.save(ml_script.name, ml_script)
        ml_script_file_path = fs.path(ml_script_file_name)
        with open(ml_script_file_path, 'r') as f:
            ml_script_content = f.read()
        os.remove(ml_script_file_path)

        train_data = request.FILES['train_data']
        train_data_file_name = fs.save(train_data.name, train_data)
        train_data_file_path = fs.path(train_data_file_name)

        with open(train_data_file_path, 'r') as f:
            train_data_content = f.read()
        path_to_train_data = train_data_file_path
        print("path_to_train_data : ",path_to_train_data)
        """
        #compiled_script = compile(ml_script_content, '<string>', 'exec')
        train_data = StringIO(train_data_content)
        exec(ml_script_content,globals())


        #os.remove(train_data_file_path)
        if 'input_for_prediction' in request.POST:
            predictict_input = request.POST['input_for_prediction']
            content = predict(predictict_input)
            print("execution finished !")
            print("content : ", content)
            return render(request, 'execute.html', {'content': content,
                                                    'ml_script_content': ml_script_content,
                                                    'train_data_content': train_data_content,
                                                    'input_for_prediction': predictict_input})
        else:
            return render(request, 'execute.html', {'content': " ",
                                                    'ml_script_content': ml_script_content,
                                                    'train_data_content': train_data_content,
                                                    'input_for_prediction': ""})

def contact_us(request):
    return render(request, 'ContactUs.html')

def send_email(request):
    user_name = request.POST['user_name']
    receiver_email = request.POST['user_email']
    subject = request.POST['subject']
    message = "FROM  : "+user_name+" / "+receiver_email+":\n"+request.POST['message']


    #this email will be sent to our team to review it later
    send_email_function(os.getenv("USER_EMAIL"),subject, message)

    message = "Your message has been received successfully!\nOur team will respond in the quickest possible.\nXml Translator."
    #this will be sen to the user to say that his message is received successfully
    send_email_function(receiver_email,"Xml Translator !","Hello,"+user_name+"!\n"+message)

    return render(request, 'ContactUs.html',{'message': 'Your message has been received successfully!'})

def send_email_function(receiver, subject, message):
    # Email credentials
    SMTP_SERVER = "smtp.gmail.com"
    SMTP_PORT = 587
    EMAIL_ADDRESS = os.getenv("USER_EMAIL")
    EMAIL_PASSWORD = os.getenv("USER_PASSWORD")  # Use App Passwords for Gmail

    # Create email message
    msg = MIMEMultipart()
    msg["From"] = EMAIL_ADDRESS
    msg["To"] = receiver
    msg["Subject"] = subject
    msg.attach(MIMEText(message, "plain"))

    # Send email
    with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
        server.starttls()  # Secure the connection
        server.login(EMAIL_ADDRESS, EMAIL_PASSWORD)
        server.sendmail(EMAIL_ADDRESS, receiver, msg.as_string())

    print("Email sent successfully!")
