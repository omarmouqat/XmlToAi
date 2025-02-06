<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="text"/>

    <xsl:template match="/Pipeline">
import torch
import torch.nn as nn
import torch.optim as optim
from sklearn.feature_extraction.text import CountVectorizer
import numpy as np
import pandas as pd

# Load training data from CSV
df = pd.read_csv(train_data)
texts = df["text"].tolist()
labels = df["label"].tolist()

# Convert texts to feature vectors
vectorizer = CountVectorizer(binary=True)
X = vectorizer.fit_transform(texts).toarray()
y = np.array(labels)

# Convert to PyTorch tensors
X_tensor = torch.tensor(X, dtype=torch.float32)
y_tensor = torch.tensor(y, dtype=torch.long)

# Define a simple text classification model
class TextClassifier(nn.Module):
    def __init__(self, input_size):
        super(TextClassifier, self).__init__()
        self.fc = nn.Linear(input_size, 2)  # Binary classification (positive or negative)

    def forward(self, x):
        return self.fc(x)

# Initialize model, loss function, and optimizer
model = TextClassifier(input_size=X.shape[1])
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=<xsl:value-of select="Training/Step/Parameters/LearningRate"/>)

# Training loop
epochs = <xsl:value-of select="Training/Step/Parameters/Epochs"/>
for epoch in range(epochs):
    optimizer.zero_grad()
    outputs = model(X_tensor)
    loss = criterion(outputs, y_tensor)
    loss.backward()
    optimizer.step()

    if (epoch+1) % 10 == 0:
        print(f'Epoch [{epoch+1}/{epochs}], Loss: {loss.item():.4f}')

# Prediction function
def predict(text):
    text_vector = vectorizer.transform([text]).toarray()
    text_tensor = torch.tensor(text_vector, dtype=torch.float32)
    output = model(text_tensor)
    prediction = torch.argmax(output, dim=1).item()
    return "<xsl:value-of select='Training/Step/Parameters/PredictContext'/>" + ("Positive" if prediction == 1 else "Negative")

    </xsl:template>

</xsl:stylesheet>
