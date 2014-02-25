import sys, json
import subprocess
import yaml

package = json.load(sys.stdin)

deps = package['dependencies'].items() + package['devDependencies'].items()

morphs = list()

for chunk in deps:
    cmd = "npm view %s repository.url" % chunk[0]
    process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
    output = process.communicate()
    print 'name:', chunk[0]
    print 'morph:', output[0].splitlines()[0]
    print 'ref:', chunk[1]

    morph={'morph':chunk[0] , 'repo':output[0].splitlines()[0], 'ref':chunk[1]}
    morphs.append(morph)

with open('data.yaml', 'a') as outfile:
    outfile.write( yaml.safe_dump(morphs, default_flow_style=False) )
