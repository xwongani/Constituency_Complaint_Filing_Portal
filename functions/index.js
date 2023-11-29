// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
const {logger} = require("firebase-functions");
const functions = require("firebase-functions");
const admin = require("firebase-admin/app");
const Sentiment = require("sentiment");

admin.initializeApp();

/**
 * Analyzes sentiment for new complaints added to Firestore.
 *
 * @param {functions.firestore.DocumentSnapshot} snapshot -snapshot of new doc.
 * @param {functions.EventContext} context - The event context.
 * @returns {Promise} A promise when the sentiment analysis is completed.
 */

exports.analyzeNewComplaintSentiment = functions.firestore
    .document("complaints/{documentId}")
    .onCreate(async (snapshot, context) => {
      try {
        const data = snapshot.data();
        const details = data.details;

        // Perform sentiment analysis on 'details' field
        const sentiment = new Sentiment();
        const detailsSentimentScore = sentiment.analyze(details).score;

        // Customize sentiment label based on score
        const detailsSentimentLabel = getSentimentLabel(detailsSentimentScore);

        // Update Firestore with sentiment label
        await snapshot.ref.update({
          detailsSentimentLabel: detailsSentimentLabel,
          priority: detailsSentimentLabel,
        });

        logger.log("Sentiment analysis completed for new complaint.");
      } catch (error) {
        logger.error("Error analyzing sentiments:", error);
      }
    });

/**
 * Customizes sentiment labels based on the provided score.
 *
 * @param {number} score - The sentiment score.
 * @return {string} The corresponding sentiment label.
 */
function getSentimentLabel(score) {
  // Customize the logic based on your desired sentiment ranges
  if (score > 1) {
    return "Low"; // Very positive
  } else if (score > 0) {
    return "Low"; // Positive
  } else if (score === 0) {
    return "Neutral";
  } else if (score >= -1) {
    return "High"; // Negative
  } else {
    return "High"; // Very negative
  }
}
