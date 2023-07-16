// This exists to reformat LanguageTool output to something easier to work with.

const fs = require('fs');

const mapping = [];
const sourceFile = fs.readFileSync(process.argv[2], 'utf8').toString();
let line = 1;
let json = '';
let lastCursor = 0;

for (let cursor = 0; cursor < sourceFile.length; cursor++) {
  if (sourceFile[cursor] === '\n') {
    mapping.push({
      end: cursor + 1,
      line: line,
      start: lastCursor + 1,
      text: sourceFile.slice(lastCursor, cursor + 1),
    });
    line += 1;
    lastCursor = cursor + 1;
  }
}

fs.writeFileSync('map.json', JSON.stringify(mapping, ' ', 2));

process.stdin.setEncoding('utf8');
process.stdin.on('data', (data) => {
  json += data;
});
process.stdin.on('end', () => {
  const issues = JSON
    .parse(json);
  const result = [];

  issues
    .matches
    .filter((i) => !(i.replacements.length > 0
      && i.replacements[0].value === 'URL'
      && i.context.text.indexOf('post_url') === 43)
    )
    .forEach((i) => {
      i.line = findLineFromOffset(i);
      result.push(i);
    });
  console.log(JSON.stringify(result, ' ', 2));
});

function findLineFromOffset(issue) {
  let offset = issue.offset;

  for (let index = 0; index < mapping.length; index++) {
    const line = mapping[index];

    if (offset >= line.start && offset <= line.end) {
      return line.line;
    }
  }

  return mapping[mapping.length - 1].line;
}
