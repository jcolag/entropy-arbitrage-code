let leftover = '';

process.stdin.setEncoding('utf8');
process.stdin.on('data', (data) => {
  const lines = (leftover + data).split('\n').map((l) => l.split(':'));

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

