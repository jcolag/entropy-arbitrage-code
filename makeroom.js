const fs = require('fs');
const path = require('path');

// This program is designed to push back a weekly series of posts, changing
// both the filename of the post and the frontmatter.

const locationPath = '_posts';
const targetNames = [];

// Validate the arguments, both that we have enough and that they
// parse correctly.
if (process.argv.length < 4) {
  console.log(`\t${process.argv[0]} ${process.argv[1]} <start-date> <weeks>`);
  process.exit(-1);
}

const startDate = new Date(process.argv[2]);
const weeks = Number(process.argv[3]);

if (startDate.getTime() !== startDate.getTime()) {
  console.log(`"${process.argv[2]}" is not a valid date.`);
  process.exit(-2);
}

if (weeks !== weeks) {
  console.log(`${weeks} is not a valid number of weeks.`);
  process.exit(-3);
}

// Shift to midday to avoid any confusion with time zones.
startDate.setHours(startDate.getHours() + 12);

let date = startDate;
let count = 0;

while(true) {
  const datePrefix = date.getFullYear() + '-'
    + ('0' + (date.getMonth() + 1)).slice(-2) + '-'
    + ('0' + date.getDate()).slice(-2) + '-';
  const newDate = new Date(date);
  const filenames = findFiles(locationPath, datePrefix);

  if (filenames.length === 0) {
    // If there aren't any files for the target date, it's probably best to
    // stop there, even though it might mean collisions for added space that's
    // larger than an existing gap.
    break;
  }

  newDate.setDate(newDate.getDate() + (7 * weeks));
  filenames.forEach((filename) => {
    // Each file needs a name that matches the target date (several weeks
    // from its original planned publication date) and the frontmatter
    // "date:" field needs to change to match it.
    const qname = path.join(locationPath, filename);
    const text = fs.readFileSync(qname).toString();
    const newPrefix = newDate.getFullYear() + '-'
      + ('0' + (newDate.getMonth() + 1)).slice(-2) + '-'
      + ('0' + newDate.getDate()).slice(-2) + '-';
    const newName = qname.replace(datePrefix, newPrefix);
    const newText = text.replace(
      `\ndate: ${datePrefix.slice(0, -1)}`,
      `\ndate: ${newPrefix.slice(0, -1)}`
    );

    // Skip files that we've already touched.
    if (targetNames.indexOf(qname) >= 0) {
      return;
    }

    console.log(`Moving ${qname} to ${newName}...`);
    targetNames.push(newName);
    try {
      // Write out the new file and delete the original.
      fs.writeFileSync(newName, newText);
      fs.unlinkSync(qname);
    } catch (e) {
      console.log(e);
      exit(-4);
    }
  });

  date.setDate(date.getDate() + 7);
  count += 1;
}

function findFiles(dir, prefix) {
  const location = fs.opendirSync(dir);
  const results = [];
  let next = location.readSync();

  while (next !== null) {
    if (next.name.indexOf(prefix) === 0) {
      results.push(next.name);
    }

    next = location.readSync();
  }

  location.closeSync();
  return results;
}

