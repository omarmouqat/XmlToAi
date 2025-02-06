<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text"/>

    <xsl:template match="/Pipeline">
import tensorflow as tf
import numpy as np
import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense

# Load training data
df = pd.read_csv(train_data)
texts = df["text"].tolist()
labels = df["label"].tolist()

# Convert texts to feature vectors
vectorizer = CountVectorizer(binary=True)
X = vectorizer.fit_transform(texts).toarray()
y = np.array(labels)

# Define Text Classification Model
model = Sequential([
    Dense(16, activation='relu', input_shape=(X.shape[1],)),
    Dense(1, activation='sigmoid')
])

# Compile model
model.compile(optimizer=tf.keras.optimizers.Adam(learning_rate=<xsl:value-of select="Training/Step/Parameters/LearningRate"/>),
              loss='binary_crossentropy',
              metrics=['accuracy'])

# Train model
epochs = <xsl:value-of select="Training/Step/Parameters/Epochs"/>
model.fit(X, y, epochs=epochs, batch_size=8, verbose=1)

# Prediction function
def predict(text):
    text_vector = vectorizer.transform([text]).toarray()
    prediction = model.predict(text_vector)[0][0]
    return "<xsl:value-of select='Training/Step/Parameters/PredictContext'/>" + ("Positive" if prediction > 0.5 else "Negative")

    </xsl:template>
</xsl:stylesheet>
