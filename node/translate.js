#!/usr/bin/env node

if (process.argv.length < 6) {
  console.log('Usage: translate.ts <url> <text> <source_lang> <target_lang>');
  process.exit(1);
}

const url = process.argv[2];
const text = process.argv[3];
const source_lang = process.argv[4];
const target_lang = process.argv[5];

const res = await fetch(url, {
  method: "POST",
  body: JSON.stringify({
    q: text,
    source: source_lang,
    target: target_lang,
  }),
  headers: { 'Content-Type': 'application/json' },
})

const json = await res.json();
process.stdout.write(json.translatedText);

