const mongoose = require('mongoose');


const ratingSchema = mongoose.Schema({
    userId: {
        type: String,
        requried: true,

    },
    rating: {
        type: Number,
        requried: true,
    },
});

module.exports = ratingSchema;