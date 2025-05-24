const express = require("express");
const admin = require("../middlewares/admin_middleware");
const { Product } = require("../models/product");
const Order = require("../models/order");
const authRouter = require("./auth");
const adminRouter = express.Router();


// all product api 
adminRouter.post('/admin/add-product', admin, async (req, res) => {
    try {
        const { name, description, images, price, quantity, category } = req.body;

        let product = new Product({
            name,
            description,
            images,
            price,
            quantity,
            category,
        });
        product = await product.save();
        res.json(product);

    } catch (e) {
        res.status(500).json({ error: e.message })

    }
});

// api to fetch all products 
adminRouter.get('/admin/get-products', admin, async (req, res) => {
    try {
        const products = await Product.find({});
        res.json(products);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})


// delete the products 

adminRouter.post('/admin/delete-product', admin, async (req, res) => {
    try {
        const { id } = req.body;
        let product = await Product.findByIdAndDelete(id);
        // product = await product.save();
        res.json(product);

    } catch (e) {
        res.status(500).json({ error: e.message });

    }
});

// get orders 
adminRouter.get('/admin/get-orders', admin, async (req, res) => {
    try {
        const orders = await Order.find({});
        res.join(orders);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// change order status 
authRouter.post("/admin/change-order-status", admin, async (req, res) => {
    try {
        const { id, status } = req.body;
        let order = await Order.findById(id);
        order.status = status;
        order = await order.save();
        res.json(order);

    } catch (e) {
        res.status(500).json({ error: e.message });

    }
})

// admin Analytics 

adminRouter.get("/admin/analytics", admin, async (req, res) => {


    try {
        const orders = await Order.find({});
        let totalEarnings = 0;

        for (let i = 0; i < orders.length; i++) {
            for (let j = 0; j < orders[i], products.length; j++) {
                totalEarnings += orders[i].products[j].quantity * orders[i].products[j].product.price
            }
        }

        // Category wise order fetching 
        let mobileEarnings = await fetchCategoryWiseProducts("Mobiles");
        let essentialEarnings = await fetchCategoryWiseProducts("Essentials");
        let applianceEarnings = await fetchCategoryWiseProducts("Appliances");
        let booksEarnings = await fetchCategoryWiseProducts("Books");
        let fashionEarnings = await fetchCategoryWiseProducts("Fashion");

        let earnings = {
            totalEarning,
            mobileEarnings,
            essentialEarnings,
            applianceEarnings,
            booksEarnings,
            fashionEarnings,
        };
        res.json(earnings);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// fetchCategorieswise products fucntion 
async function fetchCategoryWiseProducts(category) {
    let earnings = 0;
    let categoryOrders = await Order.find({ "products.product.category": category });

    for (let i = 0; i < categoryOrders.length; i++) {
        for (let j = 0; j < categoryOrders[i].products.length; j++) {
            earnings += categoryOrders[i].product[j].quantity * categoryOrders[i].products[j].product.price;
        }
    }
    return earnings;

}


module.exports = adminRouter;