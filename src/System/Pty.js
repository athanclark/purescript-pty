"use strict";

var pty = require('node-pty');

exports.spawnImpl = function spawnImpl (shell, args, params) {
  return pty.spawn(shell, args, params);
};

exports.writeImpl = function writeImpl (process, x) {
  process.write(x);
};

exports.onDataImpl = function onDataImpl (process, f) {
  process.on('data', function onDataReceiveImpl (x) {
    f(x);
  });
};

exports.resizeImpl = function resizeImpl (process, xs) {
  process.resize(xs.cols, xs.rows);
};

