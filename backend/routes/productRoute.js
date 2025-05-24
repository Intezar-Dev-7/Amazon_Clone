const auth = require("../middlewares/auth");
const { Product } = require("../models/product");
const express = require("express");
const productRouter = express.Router();




productRouter.get("/api/products/", auth, async (req, res) => {
    try {
        const products = await Product.find({ category: req.query.category });
        res.json(products);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

productRouter.get("/api/products/search/:name", auth, async (req, res) => {
    try {
        const products = await Product.find({
            name: { $regex: req.params.name, $options: 'i' },

        });
        res.join(products);

    } catch (e) {
        res.status(500).json({ error: e.message });


    }

    // create a post request to rate the product 
    // Loops through the product's ratings array to check if the current user has already rated the product.

    // If yes, it removes the old rating so it can be replaced.
    productRouter.post('/api/rate/-product', auth, async (req, res) => {
        try {
            const { id, rating } = req.body;
            let product = await Product.findById(id);

            for (let i = 0; i < product.ratings.length; i++) {
                if (product.ratings[i].userId == req.user) {
                    products.ratings.splice(i, 1);
                    break;
                }
            }
            const ratingSchema = {
                useId: req.user,
                rating,
            };

            product.ratings.push(ratingSchema);
            product = await product.save();
            res.json(product);

        } catch (e) {
            res.status(500).json({ error: e.messsage });
        }
    })
});


productRouter.get('/api/deal-of-day', auth, async (req, res) => {
    try {

        let products = await Product.find({});
        products = products.sort((a, b) => {
            let aSum = 0;
            let bSum = 0;

            for (let i = 0; i < b.ratings.length; i++) {
                aSum += a.ratings[i].rating;
            }

            for (let i = 0; i < b.ratings.length; i++) {
                bSum += b.ratings[i].rating;
            }
            return aSum < bSum ? 1 : -1;
        });
    } catch (e) {
        res.status(500).json({ error: e.message });

    }
})

module.exports = productRouter;