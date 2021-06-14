# Creatd by Tanish Gupta (tanish.gupta@amdocs.com)
# This script takes all the classes from $path variable and move it to the $target variable path.
# by creating the directories like package structure in which the .class compiled.
# This script will only update the .class file into the ear file.

echo "Starting executing shell script"

### declaration of the variables
export pathToFile="/OneDrive - AMDOCS/Backup Folders/Desktop/MyWork/work"
# export pathToFile="/JEE/OMS/application/SharedApplication"
export path="$HOME$pathToFile/classes_to_replace"
export target="$HOME$pathToFile/classes"
export earName="omsserver_weblogic.ear"
export jarName="cord9src.jar"
export allClassesToBeReplace=""

extractEarAndCreateCord9SrcBackUp(){
    export outputVar=$(jar -xvf "$earName" "$jarName")
    echo $outputVar
    cp $jarName ./$jarName'_'$(date +%d%m%y_%s)
    mv $jarName ./classes
}

fetch_class(){
        export flag="false"
        for word in $1
        do
            if [ "${flag}" == "true" ] ; then
                flag="false"
                echo "class needs to be created in classes directory $word"
                create_dir "$word" "$2" "$3"
            fi  
            if [ "${word}" == "class" ] ; then
                flag="true"
            fi  
        done
}

create_dir(){ 
    # $1:- this is the fully qualified class name
    # $2:- source directory from where to copy the class
    # $3:- target directory where to copy the class
    class_name=${1##*.} 
    classNameToBeAdd=$class_name'.class'
    class_name="$2/$class_name.class"
    directory=${1%.*}
    directory=${directory//.//}
    pathToBeAdd=$directory'/'
    directory34=$directory
    allClassesToBeReplace+=$pathToBeAdd''$classNameToBeAdd' '
    directory="$3/$directory/"
    mkdir -p "$directory"
    cp -f "$class_name" "$directory"
}

# . ${SETENV_SCRIPT}
execute(){
    if [ -z "$(ls -A "$path")" ]; then
    echo "No Class found in directory $path to put in classes directory"
    else
        for entry in "$path"/*
            do
            export var=$(javap "$entry" utility 2>&1 | head -n 2 | tail -n 1)
            if [[ "$var" == *"class"* ]]; then
                fetch_class "$var" "$path" "$target"
            fi
        done
    fi
}

updateCord9Src(){
    echo $(cd "$target" && jar -uvf cord9src.jar $allClassesToBeReplace)
    echo $(cd "$target" && mv cord9src.jar ./..)
}

updateEar(){
    echo $(jar -uvf $earName $jarName)
}

echo $earName'updatation starts'
extractEarAndCreateCord9SrcBackUp
execute
echo allClassesToBeReplace   :   $allClassesToBeReplace
updateCord9Src
updateEar
rm $jarName
echo $earName   'updatation ends'

