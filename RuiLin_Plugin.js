/*
 * 自定义插件的js模块文件
 * 这里仿照官方的方法将Cordova.exec()包装成插件.插件方法()的格式
 */

'use strict';

var exec = require('cordova/exec');

var RuiLin_Plugin = {
    
    verifyPassword: function(sendMsg, onSuccessFuction, onFailFuction) {
    
        return exec(onSuccessFuction, onFailFuction, 'RuiLin_Plugin', 'verifyPassword', sendMsg);
    
    },
    
    getRealAddress: function(sendLoc, onSuccess, onFail) {
    
        return exec(onSuccess, onFail, 'RuiLin_Plugin', 'getRealAddress', sendLoc);
    }
    
};


module.exports = RuiLin_Plugin;

