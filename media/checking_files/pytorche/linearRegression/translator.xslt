<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text"/>

    <xsl:template match="/Pipeline">
import torch
import torch.nn as nn
import torch.optim as optim
import numpy as np
import pandas as pd

# Load training data
df = pd.read_csv('train_data.csv')
X = df[['feature']].values.astype(np.float32)
y = df['target'].values.astype(np.float32)

# Convert to PyTorch tensors
X_tensor = torch.tensor(X, dtype=torch.float32)
y_tensor = torch.tensor(y, dtype=torch.float32).view(-1, 1)

# Define Linear Regression Model
class LinearRegression(nn.Module):
    def __init__(self):
        super(LinearRegression, self).__init__()
        self.linear = nn.Linear(1, 1)

    def forward(self, x):
        return self.linear(x)

# Initialize model, loss function, and optimizer
model = LinearRegression()
criterion = nn.MSELoss()
optimizer = optim.SGD(model.parameters(), lr=<xsl:value-of select="Training/Step/Parameters/LearningRate"/>)

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
def predict(value):
    input_tensor = torch.tensor([[float(value)]], dtype=torch.float32)
    output = model(input_tensor).item()
    return "<xsl:value-of select='Training/Step/Parameters/PredictContext'/>" + str(output)

    </xsl:template>
</xsl:stylesheet>
