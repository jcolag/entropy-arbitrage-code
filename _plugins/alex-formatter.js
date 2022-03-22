// This exists to format alex (alexjs.com) output to sensible JSON.

module.exports = function(results, context) {
  return JSON.stringify(
    results[0].messages.sort((a,b) => a.line - b.line),
    ' ',
    2);
};
