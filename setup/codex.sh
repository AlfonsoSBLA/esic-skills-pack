#!/usr/bin/env bash
# Setup esic-skills-pack para OpenAI Codex CLI
# Codex usa estructura .codex/agents/ — adaptamos las skills al formato esperado

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "🔧 Setup esic-skills-pack para Codex"
echo "📁 Repo: $REPO_ROOT"

# Codex CLI lee desde .codex/agents/ (o equivalente según versión)
mkdir -p .codex/agents

# Por cada skill, crear el agent file que Codex espera
for skill_dir in skills/*/; do
    skill_name=$(basename "$skill_dir")
    skill_file="$skill_dir/SKILL.md"

    if [ ! -f "$skill_file" ]; then
        continue
    fi

    # Codex usa AGENTS.md por convención. Copiamos el SKILL.md como agent.md
    cp "$skill_file" ".codex/agents/${skill_name}.md"
done

echo "✅ Skills adaptadas a .codex/agents/ ($(ls .codex/agents | wc -l | xargs) archivos)"
echo ""
echo "🚀 Próximo paso:"
echo "   codex"
echo ""
echo "   Para invocar una skill: pega el contenido del agent al inicio del chat"
echo "   o usa el comando de Codex para cargar agent (varía según versión)"
echo ""
echo "⚠️  Nota: Codex no carga skills automáticamente como Claude Code."
echo "   Para mejor experiencia, considera usar Claude Code (bash setup/claude-code.sh)"
