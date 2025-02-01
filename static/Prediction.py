
def exc():
    file = open("script_py.py", "r")
    script = str(file.read())
    path_to_train_data = 'training_data.csv'
    # Step 1: Run only the class definition and function definitions
    exec("\n".join(script.split("\n")[:20]), globals())  # Adjust slicing as needed

    # Step 2: Run the rest (model instantiation & training)
    exec("\n".join(script.split("\n")[20:]), globals())

    print(predict("I love AI"))
    print(predict("Debugging is hard"))
exc()
"""
while gender!='q':
    weight = predict_weight( height)
    gender = "Male"
    print(f'Predicted Weight: {weight}')
    print(f'Equation: Weight = {intercept} + ({coefficients[0]} * Gender) + ({coefficients[1]} * Height)')
    gender = input('Enter Gender (Male, Female): ')
    height = float(input('Enter Height: '))
gender = input('Enter Gender: ')
height = float(input('Enter Height: '))



# Generate synthetic training data and save to CSV
data = {
    "text": [
        "I love programming", "Python is great", "I enjoy learning AI", "Deep learning is fascinating",
        "I hate bugs", "Debugging is frustrating", "Errors are annoying", "I dislike slow code"
    ],
    "label": [1, 1, 1, 1, 0, 0, 0, 0]
}
df = pd.DataFrame(data)
df.to_csv("training_data.csv", index=False)




"""
