const HtmlWebpackPlugin = require("html-webpack-plugin");
const common = require("./webpack.config.js");
module.exports = {
  ...common,
  optimization: {
    minimize: true,
  },
  devtool: false,

  plugins: [    
    new HtmlWebpackPlugin({
      title: "this is the title",
      template: "./src/index.html",
    }),
],
};
