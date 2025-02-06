<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text"/>

    <xsl:template match="/Pipeline">
import tensorflow as tf
import numpy as np
import pandas as pd

# Load training data
df = pd.read_csv(train_data)
X = df[['feature']].values.astype(np.float32)
y = df[['target']].values.astype(np.float32)

# Define model
model = tf.keras.Sequential([
    tf.keras.layers.Dense(1, input_shape=(1,))
])

# Compile model
model.compile(optimizer=tf.keras.optimizers.SGD(learning_rate=<xsl:value-of select="Training/Step/Parameters/LearningRate"/>),
              loss='mse')

# Train model
epochs = <xsl:value-of select="Training/Step/Parameters/Epochs"/>
model.fit(X, y, epochs=epochs, verbose=1)

# Prediction function
def predict(value):
    prediction = model.predict([[float(value)]])[0][0]
    return "<xsl:value-of select='Training/Step/Parameters/PredictContext'/>" + str(prediction)

    </xsl:template>
</xsl:stylesheet>
