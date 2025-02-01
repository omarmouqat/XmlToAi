// Initialize the CodeMirror editor
var editor = CodeMirror.fromTextArea(document.getElementById('output'), {
    mode: 'python', // Set the mode to XML
    lineNumbers: true, // Display line numbers
    theme: 'dracula', // Set the theme to dracula (you can change this)
    indentUnit: 4, // Set indentation level
    matchBrackets: true, // Highlight matching brackets
    autoCloseTags: true, // Auto close XML tags
    lineWrapping: true, // Enable line wrapping for long lines
});
editor.getWrapperElement().style.height = '450px';

// Initialize the CodeMirror editor
const form = document.getElementById("file_form");
const file = document.getElementById("file");
//const code = document.getElementById("code");
const code_in_form = document.getElementById("code_in_form");
const button_submit = document.getElementById("submit_tansform");
var editor = CodeMirror.fromTextArea(document.getElementById('code'), {
    mode: 'xml', // Set the mode to XML
    lineNumbers: true, // Display line numbers
    theme: 'dracula', // Set the theme to dracula (you can change this)
    indentUnit: 4, // Set indentation level
    matchBrackets: true, // Highlight matching brackets
    autoCloseTags: true, // Auto close XML tags
    lineWrapping: true, // Enable line wrapping for long lines
});
editor.getWrapperElement().style.height = '450px';

//automaticlly submit the first form after uploading a file
file.addEventListener("change",function(){
    form.submit();
})

//initialize the value of the input to match the code value
code_in_form.value = editor.getValue();


button_submit.addEventListener("click",function () {
    code_in_form.innerText = editor.innerHTML;
})

//working on coppying the value of the code section into the form field
editor.on("change", function () {
    code_in_form.value = editor.getValue();
})
function syncCodeMirrorToHiddenInput() {
    code_in_form.value = editor.getValue();
}