cd src

echo "Generating random items"
ruby generator/item-generator.rb > ./items.txt
cp items.txt ./visualization/app/items.txt

echo "Generating facts"
ruby generator/fact-generator.rb > facts.pl

echo "Generating action log"
python logic/logic.py > ./visualization/app/action-log.json

echo "Running gulp"
cd visualization
nw.exe
