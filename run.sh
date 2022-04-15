if ! command -v npx
then
    echo "npx is required to be installed for this script"
    exit
fi

echo "Creating a new project using create-react-app"
npx create-react-app $1
cd $1

echo "Adding tailwindcss, postcss and autoprefixer as a dependency"
npm add -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

echo "Configuring valid files glob for tailwindcss.config.js"
cat <<EOT > tailwind.config.js
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOT

echo "Configuring src/index.css"
cat <<EOT > src/index.css
@tailwind base;
@tailwind components;
@tailwind utilities;
EOT

sed -i '' 's|<code>|<code className="border-2 border-indigo-500 bg-indigo-900 rounded-xl p-2">|' src/App.js