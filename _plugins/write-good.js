// SPDX-FileCopyrightText: 2020 John Colagioia <john@colagioia.net>
//
// SPDX-License-Identifier: AGPL-3.0-or-later

// This exists to format write-good's colon-separated output to
// more sensible JSON.

let leftover = '';
let json = '';

process.stdin.setEncoding('utf8');
process.stdin.on('data', (data) => {
  json += data;
});
process.stdin.on('end', () => {
  const lines = (leftover + json).split('\n').map((l) => l.split(':'));

  if (lines[-1] !== '') {
    leftover = lines[-1];
  } else {
    leftover = '';
  }

  lines.pop();
  console.log(
    JSON.stringify(
      lines.map((l) => ({
        line: l[1],
        offset: l[2],
        message: l[3],
      })),
      ' ',
      2
    )
  );
});

