/**
 * Studio Silo — proxy de chat (Cloudflare Worker)
 * ------------------------------------------------
 * Le site envoie { system, messages } ; ce worker appelle l'API Claude avec votre clé
 * (jamais exposée côté navigateur) et renvoie { text }.
 *
 * Déploiement (5 minutes) :
 *   1. npm i -g wrangler && wrangler login
 *   2. wrangler init studiosilo-chat  → remplacez src/index.js par ce fichier
 *   3. wrangler secret put ANTHROPIC_API_KEY
 *   4. wrangler deploy  → copiez l'URL dans SILO_CONFIG.chatEndpoint (index.html)
 *
 * Variables optionnelles (wrangler.toml [vars]) :
 *   ALLOWED_ORIGIN = "https://studiosilo.fr"   (CORS ; "*" par défaut)
 *   MODEL          = "claude-sonnet-5"          (modèle par défaut ci-dessous)
 */
export default {
  async fetch(request, env) {
    const origin = env.ALLOWED_ORIGIN || "*";
    const cors = {
      "Access-Control-Allow-Origin": origin,
      "Access-Control-Allow-Methods": "POST, OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type",
    };
    if (request.method === "OPTIONS") return new Response(null, { headers: cors });
    if (request.method !== "POST") return new Response("Method not allowed", { status: 405, headers: cors });

    let body;
    try { body = await request.json(); } catch { return json({ error: "invalid_json" }, 400, cors); }
    const { system = "", messages = [] } = body;
    if (!Array.isArray(messages) || !messages.length) return json({ error: "no_messages" }, 400, cors);

    // Garde-fous : taille et rôles
    const clean = messages
      .filter(m => m && (m.role === "user" || m.role === "assistant") && typeof m.content === "string")
      .slice(-14)
      .map(m => ({ role: m.role, content: m.content.slice(0, 2000) }));
    if (!clean.length || clean[clean.length - 1].role !== "user") return json({ error: "bad_turns" }, 400, cors);

    const r = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "content-type": "application/json",
        "x-api-key": env.ANTHROPIC_API_KEY,
        "anthropic-version": "2023-06-01",
      },
      body: JSON.stringify({
        model: env.MODEL || "claude-sonnet-5",
        max_tokens: 600,
        system: String(system).slice(0, 60000),
        messages: clean,
      }),
    });
    if (!r.ok) return json({ error: "upstream", status: r.status }, 502, cors);
    const data = await r.json();
    const text = (data.content || []).filter(b => b.type === "text").map(b => b.text).join("");
    return json({ text }, 200, cors);
  },
};

function json(obj, status, headers) {
  return new Response(JSON.stringify(obj), { status, headers: { ...headers, "content-type": "application/json" } });
}
