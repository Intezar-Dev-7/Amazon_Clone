
// Import From packages
const express = require("express");
const mongoose = require("mongoose");



// Import from other files 
const authRouter = require("./routes/auth");
const adminRouter = require("./routes/admin");
const userRouter = require("./routes/userRoute");
const productRouter = require("./routes/productRoute");




//  Initialization 
const PORT = 3000;
const app = express();

const DBURL = "mongodb+srv://<username>:<password>@cluster0.tbmxtxh.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";


// Middleware
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);

// Connections 
mongoose.connect(DBURL).then(() => {
    console.log('Connection Successull');
}).catch((e) => {
    console.log(e);
});

app.listen(PORT, "0.0.0.0", () => {
    console.log("Connected");
});
