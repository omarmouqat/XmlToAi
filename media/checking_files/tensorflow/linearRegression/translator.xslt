<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text"/>

    <xsl:template match="/">

        <!-- Import TensorFlow and numpy -->
        <xsl:text>import tensorflow as tf&#10;import numpy as np&#10;&#10;</xsl:text>

        <!-- Preprocessing Step -->
        <xsl:for-each select="Pipeline/Preprocessing/Step">
            <xsl:choose>
                <xsl:when test="Name='Normalize'">
                    <xsl:text>def normalize(data):&#10;</xsl:text>
                    <xsl:text>    return (data - np.mean(data, axis=0)) / np.std(data, axis=0)&#10;&#10;</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>

        <!-- Training Step -->
        <xsl:for-each select="Pipeline/Training/Step">
            <xsl:choose>
                <xsl:when test="Name='ModelTraining'">
                    <xsl:text>model = tf.keras.Sequential([&#10;</xsl:text>
                    <xsl:text>    tf.keras.layers.Dense(1)&#10;</xsl:text>
                    <xsl:text>])&#10;&#10;</xsl:text>
                    <xsl:text>model.compile(optimizer=tf.keras.optimizers.Adam(learning_rate=</xsl:text>
                    <xsl:value-of select="Parameters/LearningRate"/>
                    <xsl:text>)&#10;              , loss='mean_squared_error')&#10;&#10;</xsl:text>
                    <xsl:text>model.fit(train_data, train_labels, epochs=</xsl:text>
                    <xsl:value-of select="Parameters/Epochs"/>
                    <xsl:text>, batch_size=</xsl:text>
                    <xsl:value-of select="Parameters/BatchSize"/>
                    <xsl:text>)&#10;&#10;</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>

        <!-- Validation Step -->
        <xsl:for-each select="Pipeline/Validation/Step">
            <xsl:choose>
                <xsl:when test="Name='ModelEvaluation'">
                    <xsl:text>loss = model.evaluate(test_data, test_labels)&#10;</xsl:text>
                    <xsl:text>print('Mean Squared Error:', loss)&#10;</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>

    </xsl:template>
</xsl:stylesheet>
