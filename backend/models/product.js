const mongoose = require("mongoose");
const ratingSchema = require("./rating");


const productSchema = mongoose.Schema({
    name: {
        type: String,
        requried: true,
        trim: true,

    },
    description: {
        type: String,
        required: true,
        trim: true,
    },
    images: [
        {
            type: String,
            requried: true,

        }
    ],


    price: {
        type: Number,
        rqeuired: true,

    },
    quantity: {
        type: Number,
        required: true,

    },
    category: {
        type: String,
        requried: true,

    },
    ratings: [ratingSchema],
});

const Product = mongoose.model("Product", productSchema);

module.exports = { Product, productSchema };
