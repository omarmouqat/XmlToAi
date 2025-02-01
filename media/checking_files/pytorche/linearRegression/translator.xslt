<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" />

    <!-- Root template -->
    <xsl:template match="/">
        <xsl:text>import torch</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>import torch.nn as nn</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>import torch.optim as optim</xsl:text>
        <xsl:text>&#10;&#10;</xsl:text>

        <!-- Preprocessing Step -->
        <xsl:for-each select="Pipeline/Preprocessing/Step">
            <xsl:choose>
                <xsl:when test="Name='Normalize'">
                    <xsl:text>def normalize_data(images):</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>    return images / 255.0</xsl:text>
                    <xsl:text>&#10;&#10;</xsl:text>
                </xsl:when>
                <!-- Add more preprocessing steps here if needed -->
            </xsl:choose>
        </xsl:for-each>

        <!-- Training Step -->
        <xsl:for-each select="Pipeline/Training/Step">
            <xsl:choose>
                <xsl:when test="Name='ModelTraining'">
                    <xsl:text>class SimpleCNN(nn.Module):</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>    def __init__(self):</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>        super(SimpleCNN, self).__init__()</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>        self.conv1 = nn.Conv2d(3, 32, kernel_size=3, padding=1)</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>        self.pool = nn.MaxPool2d(2, 2)</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>        self.fc1 = nn.Linear(32 * 56 * 56, 128)</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>        self.fc2 = nn.Linear(128, 10)</xsl:text>
                    <xsl:text>&#10;</xsl:text>

                    <xsl:text>    def forward(self, x):</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>        x = self.pool(torch.relu(self.conv1(x)))</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>        x = x.view(-1, 32 * 56 * 56)</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>        x = torch.relu(self.fc1(x))</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>        x = self.fc2(x)</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>        return x</xsl:text>
                    <xsl:text>&#10;&#10;</xsl:text>

                    <!-- Initialize the model -->
                    <xsl:text>model = SimpleCNN()</xsl:text>
                    <xsl:text>&#10;&#10;</xsl:text>

                    <!-- Define optimizer and loss function -->
                    <xsl:text>optimizer = optim.Adam(model.parameters(), lr=</xsl:text>
                    <xsl:value-of select="Parameters/LearningRate"/>
                    <xsl:text>)</xsl:text>
                    <xsl:text> &#10;</xsl:text>
                    <xsl:text>criterion = nn.CrossEntropyLoss()</xsl:text>
                    <xsl:text>&#10;&#10;</xsl:text>

                    <!-- Train model -->
                    <xsl:text>for epoch in range(</xsl:text>
                    <xsl:value-of select="Parameters/Epochs"/>
                    <xsl:text>) &#10;</xsl:text>
                    <xsl:text>    # Training loop code here</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                </xsl:when>
                <!-- Add more training steps here if needed -->
            </xsl:choose>
        </xsl:for-each>

        <!-- Validation Step -->
        <xsl:for-each select="Pipeline/Validation/Step">
            <xsl:choose>
                <xsl:when test="Name='AccuracyCheck'">
                    <xsl:text># Evaluate the model</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>model.eval()</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>with torch.no_grad():</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>    correct = 0</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>    total = 0</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>    running_loss = 0.0</xsl:text>
                    <xsl:text>&#10;</xsl:text>

                    <!-- Assuming 'validation_loader' is the DataLoader for the validation dataset -->
                    <xsl:text>    for inputs, labels in validation_loader:</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>        # Forward pass</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>        outputs = model(inputs)</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>        loss = criterion(outputs, labels)</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>        # Accumulate the loss</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>        running_loss += loss.item()</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>        # Calculate accuracy</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>        _, predicted = torch.max(outputs, 1)</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>        total += labels.size(0)</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>        correct += (predicted == labels).sum().item()</xsl:text>
                    <xsl:text>&#10;</xsl:text>

                    <xsl:text>    # Calculate the average loss and accuracy for the entire validation set</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>    avg_loss = running_loss / len(validation_loader)</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>    accuracy = 100 * correct / total</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>    print(f'Validation Loss: {avg_loss:.4f}, Accuracy: {accuracy:.2f}%')</xsl:text>
                    <xsl:text>&#10;&#10;</xsl:text>
                </xsl:when>
                <!-- Add more validation steps here if needed -->
            </xsl:choose>
        </xsl:for-each>

    </xsl:template>
</xsl:stylesheet>
