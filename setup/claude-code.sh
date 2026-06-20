#!/usr/bin/env bash
# Setup esic-skills-pack para Claude Code
# Crea symlink .claude/skills/ → ../skills/ para que Claude Code cargue las 14 skills

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "🔧 Setup esic-skills-pack para Claude Code"
echo "📁 Repo: $REPO_ROOT"

# Asegurar que existe directorio .claude/
mkdir -p .claude

# Si ya existe .claude/skills/ como directorio real (no symlink), backup
if [ -d ".claude/skills" ] && [ ! -L ".claude/skills" ]; then
    echo "⚠️  .claude/skills/ existe como directorio. Haciendo backup → .claude/skills.bak/"
    mv .claude/skills .claude/skills.bak
fi

# Si existe symlink viejo, removerlo
if [ -L ".claude/skills" ]; then
    rm .claude/skills
fi

# Crear symlink limpio
ln -s "../skills" .claude/skills

# Verificar
if [ -L ".claude/skills" ]; then
    echo "✅ Symlink creado: .claude/skills → ../skills"
    echo ""
    echo "🚀 Próximo paso:"
    echo "   claude"
    echo ""
    echo "   Las 14 skills estarán disponibles. Verifica con: /help"
else
    echo "❌ Error creando symlink. Revisa permisos."
    exit 1
fi
