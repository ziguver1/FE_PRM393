const API_KEY = "api key to test";

const BASE_URL = "https://generativelanguage.googleapis.com/v1beta";

const models = [
  "gemini-2.0-flash",
  "gemini-2.0-flash-lite",
  "gemini-2.5-flash",
  "gemini-2.5-flash-lite",
  "gemini-1.5-flash",
  "gemini-1.5-flash-8b",
];

async function testModel(model) {
  const url = `${BASE_URL}/models/${model}:generateContent?key=${API_KEY}`;

  try {
    const response = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        contents: [
          {
            role: "user",
            parts: [
              {
                text: "Reply only: ok",
              },
            ],
          },
        ],
        generationConfig: {
          maxOutputTokens: 10,
          temperature: 0,
        },
      }),
    });

    const data = await response.json();

    if (response.ok) {
      console.log(`✅ ${model} usable`);
      return;
    }

    const message = data?.error?.message || JSON.stringify(data);

    if (response.status === 429) {
      console.log(`🟡 ${model} quota/rate limit: ${message}`);
    } else if (response.status === 404) {
      console.log(`❌ ${model} not found/not supported`);
    } else if (response.status === 403) {
      console.log(`🔒 ${model} forbidden/API key issue`);
    } else {
      console.log(`⚠️ ${model} error ${response.status}: ${message}`);
    }
  } catch (error) {
    console.log(`💥 ${model} failed: ${error.message}`);
  }
}

async function main() {
  for (const model of models) {
    await testModel(model);
  }
}

main();