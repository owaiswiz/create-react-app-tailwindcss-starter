if ! command -v jq
then
    echo "jq is required to be installed for this script"
    exit
fi

if ! command -v npx
then
    echo "npx is required to be installed for this script"
    exit
fi

if ! command -v yarn
then
    echo "yarn is required to be installed for this script"
    exit
fi

echo "HERE"
npx create-react-app $1
cd $1
yarn add tailwindcss --dev
npx tailwind init tailwind.js --full
yarn add postcss-cli autoprefixer --dev

cat <<EOT >> postcss.config.js
const tailwindcss = require('tailwindcss');
module.exports = {
    plugins: [
        tailwindcss('./tailwind.js'),
        require('autoprefixer'),
    ],
};
EOT

mkdir src/styles

cat <<EOT > src/styles/index.css
@tailwind base;
@tailwind components;
@tailwind utilities;
EOT

touch src/styles/tailwind.css


jq '.scripts={
"build:style":"tailwind build src/styles/index.css -o src/styles/tailwind.css",
"watch:style": "tailwind build src/styles/index.css -o src/styles/tailwind.css --watch",
"start": "npm run build:style && react-scripts start",
"build": "react-scripts build",
"test": "react-scripts test",
"eject": "react-scripts eject"
}' package.json > package.json.temp
mv package.json.temp package.json

rm -rf src/index.css
rm -rf src/App.css

sed -i 's/\.\/index.css/.\/styles\/tailwind.css/' src/index.js
sed -i '/App.css/d' src/App.js
