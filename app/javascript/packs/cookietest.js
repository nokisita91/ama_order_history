window.Cookies = require("js-cookie")

$(function(){
  $('.c-btn').hover(function(){
    //マウスカーソルが乗った時
    $(this).css('color','blue');
    },
    function(){
    //マウスカーソルが外れた時
    $(this).css('color','white');
    })});