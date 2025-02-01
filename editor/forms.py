from django import forms
from django_ace import AceWidget

class TextEditorForm(forms.Form):
    text = forms.CharField(widget=AceWidget(mode='text', theme='monokai'), label='')
