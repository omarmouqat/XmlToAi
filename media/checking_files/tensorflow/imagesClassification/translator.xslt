<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" />

    <!-- Root template -->
    <xsl:template match="/">
        <xsl:text>import tensorflow as tf</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>import numpy as np</xsl:text>
        <xsl:text>&#10;&#10;</xsl:text>

        <!-- Preprocessing Step -->
        <xsl:for-each select="Pipeline/Preprocessing/Step">
            <xsl:choose>
                <xsl:when test="Name='ImageResize'">
                    <xsl:text>def resize_images(images, height, width):</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>    return tf.image.resize(images, [</xsl:text>
                    <xsl:value-of select="Parameters/Height"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="Parameters/Width"/>
                    <xsl:text>])</xsl:text>
                    <xsl:text>&#10;&#10;</xsl:text>
                </xsl:when>
                <!-- Add more preprocessing steps here if needed -->
            </xsl:choose>
        </xsl:for-each>

        <!-- Training Step -->
        <xsl:for-each select="Pipeline/Training/Step">
            <xsl:choose>
                <xsl:when test="Name='ModelTraining'">
                    <xsl:text>model = tf.keras.models.Sequential([</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>    tf.keras.layers.Conv2D(32, (3, 3), activation='relu', input_shape=(128, 128, 3)),</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>    tf.keras.layers.MaxPooling2D((2, 2)),</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>    tf.keras.layers.Flatten(),</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>    tf.keras.layers.Dense(128, activation='relu'),</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>    tf.keras.layers.Dense(10, activation='softmax')</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>])</xsl:text>
                    <xsl:text>&#10;&#10;</xsl:text>

                    <!-- Compile model -->
                    <xsl:text>model.compile(optimizer=tf.keras.optimizers.Adam(learning_rate=</xsl:text>
                    <xsl:value-of select="Parameters/LearningRate"/>
                    <xsl:text>),</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>              loss='sparse_categorical_crossentropy',</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>              metrics=['accuracy'])</xsl:text>
                    <xsl:text>&#10;&#10;</xsl:text>

                    <!-- Train model -->
                    <xsl:text>model.fit(train_images, train_labels, epochs=10)</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                </xsl:when>
                <!-- Add more training steps here if needed -->
            </xsl:choose>
        </xsl:for-each>

    </xsl:template>
</xsl:stylesheet>
