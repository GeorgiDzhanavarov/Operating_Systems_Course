### Get string length
```bash
strvar="Linux" 
${#strvar}
expr length $strvar
echo $strvar | awk '{print length}'
```

### find
```bash
find ~/ -type f -printf "%f\n" 2>/dev/null # намира именета на всички файлове в home директорията на текущия потребител
# -L - follow symbolic link
# -type l - всички файлове, които са symbolic link
find -L /home/students -type l 2>/dev/null # намира всички symbolic links с несъществуващ destination
find ~/ -maxdepth 1 -type f 2>/dev/null -exec basename {} \; # намира файловете само в текущата директория (не търси във вътрешните директории)
find . -size 10k -print # find all files greater than 10k in the current directory
# ! -name ".*" - името не трябва да запова с .
# %T@ - last modification time: 1655403381.2271924640 
find ~/ -type f ! -name ".*" -printf "%T@ %f\n" 2>/dev/null | sort -n -t ' ' -k1 | tail -1 # find the most recently modified regular file
find ~/ -mmin -15 -type f # find the files modified in the last 15 minutes
find ~/ -type f -printf "%s %f\n" | sort -n | tail -1 # find the biggest file
#  %Y -File's  type  (like %y), plus follow symbolic links: `L'=loop, `N'=nonexistent, `?' for any other error when determining the type of the target of a symbolic link.
```

### stat
```bash
# %N - quoted file name with dereference if symbolic link
# if symbolic link: '/home/students/s62577/baba' -> '/foo/bar/baz'
stat -c %N file_path | cut -d "'" -f 4 # връща файла, към който сочи symbolic link или празен стринг
stat -c %h /home/students/s62577/test.txt # number of hard links
stat -c %u path # намира uid на собственика на файла, %U - username of the owner
stat -c %A path # връща правата на файла/директорията в human readable format (-rw-r--r--), %a - в octal format (755)
```

### sed
```bash
echo "some other another" | sed -E "s/([^ ]+ [^ ]+) (.*)/\1 insert \2/" # вмъкване на стойнот на определено място
sed -i "s/pattern/replace_value/g; s/pattern2/replace_val2/" "file_path" # edit files in place (модифицира самия фйал) -i --in-place
```

### cut
```bash
cut -d " " -f 1 # split by space and get the first column
cut -d "," -f 2,5 # 2, 5
cut -d "," -f 2-5 # 2, 3, 4, 5
cut -c 3 # get the third character
cut -c 2,3,4 # get 2-nd, 3-rd and 4-th characters
cut -c 2-10 # get from 2-nd to 10-th characters
echo "abcdefgh" | cut -c 3- # cdefgh
echo "abcdefgh" | cut -c 3 # c
echo "abcdefgh" | cut -c 2,3,5 # bce
echo "abcdefgh" | cut -c 2-6 # bcdef
```

### sort
```bash
sort -t '-' -k2,2 -k1,1 < people.txt # sort by second column, then by first column
sort -t '-' -k3,3 -k1r,1 # sort by third column acs, then by first column desc
sort -V # version sort (5.12.1, 6.12.5 и т.н.)
sort -t '.' -n -k 1,1 -k 2,2 -k 3,3 # sort by col 1, then by col 2, then by col 3
```

### file
```bash
file /home/students/s62577/ops # /home/students/s62577/ops: broken symbolic link to destination.txt
```

### tr
```bash
tr -d "'" # delete all of the occurrences of '
```

### uniq
```bash
uniq -c | awk '{$1=$1}1' # --count всеки запис колко пъти се среща (добавя като първа колона бройката, но има и whitespaces отпред, затова ги махаме с awk)
```

### grep
```bash
# Represents extended global regular expression
cat | egrep "^[-]?[0-9]+$" | sort -n > "${temp}" # чете входа от клавиатурата, взима само числата, сортира и ги записва във файл
if egrep -q "pattern" file_name ; then - # проверка дали се match-ва pattern-a в съдържанието на файлa -q = quiet
egrep "(foo|bar)" file.txt # match all the lines in file.txt, which contains "foo" or "bar"
# grep -v - reversed match
# grep -i - case insensitive searchable
# grep -r - recursive searchable
# grep -o - show matched part of the string
```
### ps
```bash
ps -u "root" -o pid #връща process id-тата на всички текущи процеси на root потребителя
ps -eo -pid,user,args -- sort user # сортира по user
ps -e -o user=,pid= # показва всички активни процеси с потребителското име и идентификатора на процеса. След user и pid има = - това премахва header-a
ps -e -o etimes # връща колко секунди е работил прцеоса
```
### Common utilities
* mkdir -p
* symbolic link - l in the listing
* file path_to_symbolic_link -> file path_to_symbolic_link: symbolic link to path
* ln -s path_to_file link_name
* readlink path_to_link
* readlpath
* ls -lh - принтира размера в human readable format
* -v - verbose - дава ни повече информация
* diff - report identical files
* cp -r dir destination_dir
* echo L3{a,b,c}456
* ${x%.webm}.ogg
* $((2 + 3 * 5))
* ? - кой да е символ
* $@, $* - списък на всички аргументи
* $? - exit код от последната изпълнена команда
```bash
echo "2 * 2 + 2" | bc # 8
dirname /home/students/s62577/test.txt # /home/students/s62577
tempFile="${mktemp}" # съзадава временен файл и връща пътя до него
# Change file permissions
chmod 775 file
chmod -R 775 folder # recursively chmod folder to 775
date +%d.%m.%Y ?? # 18.06.2022
```
### Input and output redirection
```bash
cmd1 <(cmd2) # Output of cmd2 as input to cmd1
cmd 2> file # cmd 2>/dev/null
cmd 1>&2 # stdout to same place as stderr
```
### Kill processes
```bash
kill -s SIGTERM pid_id
kill -s SIGKILL pid_id
pkill name # kill process with name name
killall name # kill all processes with names beginning name
```
### Calculations and arithmetic operations
```bash
count=1
count=$(expr $count + 1) # увеличаване на стойността със единица
```
### Shell parameter expansion
```bash
CUR_FILE="${!CUR_ARG}" # ако CUR_ARG e 1, тогава все едно пишем "$1", тоест първо изчислява израза в скобите и след това взима стойността
test=me
me=145
echo ${!test} #145
value="paterna"; echo ${value%?} # pattern - маха последния символ
name="file.txt"; echo ${name%.txt}.raw # name.raw - полезно за смяна на file extension
```
### if statements
* if then fi
* if then else fi
* if then elif else fi
```bash
# проверява дали процеса се изпълнява от потребител различен от root
if [ $(id -u) -ne 0 ]; then
    echo "non root user"
fi
[ -x "${DIR_PATH}" ] || { echo "Directory is not searchable"; exit 4; }
[ -r "${DIR_PATH}" ] || { echo "Directory is not readable"; exit 3; }
a="5"; b="6"
[ $a -lt $b ] && [ $a -eq 5 ] && { echo "test"; }
```
### File test operators
* -e - to test if file exists
* -f - regular file
* -d - directory
* -b - to test if the file is block device
* -s - to test if the file is not zero size
* -L - test if the file is symbolic link
* S - test if the file is socket
* -r - if the file has read permissions
* -w - write permissions
* -x - execute permissions
* -O - test if you are the owner of the file
* f1 -nt f2 - file f1 is newer than f2
* f1 -ot f2 - file  f1 is older than f2
### Integer comparison operators
* -eq, -ne, -gt, -ge, -lt, -le
### String comparison operators
* ==, !=, <, <=, >, >=
* -z - string is null
* -n - string is not null
### Loops
* for do done
* while do done
* until do done
```bash
# подаване на изхода на команда като вход на while loop
while read line; do
        echo "$line"
done < <(find ~/ -type d -name "d*" 2>/dev/null)
```
### Functions
```bash
# Count hardlinks demo
function count_hardlinks() {
    find "$1" -samefile "$2" 2>/dev/null | wc -l
}
hardlinks=$(count_hardlinks ~/ /home/students/s62577/test.txt)
echo $hardlinks
# Check if symbol link is broken
function is_broken_symlink {
	file "${1}" | grep -q 'broken'
}
# valdiate number demo
function validate_num() {
    echo "$1" | egrep -q "^-?[0-9]+$"
}
num=14
if validate_num "$num"; then
        echo "Valid number"
else
        echo "Invalid number"
fi
```
### Bash arrays and functions
* array=("elements of the array")
* ${array[0]} - get the first element of the array
* ${array[*]} - get all values in the array
* ${array[-1]} - get the last value in the array
* ${array[@]} - expand all the array elements
* shift
* function() { content-of-function }
### Regular expressions
* {N} - the preceding item is matched exactly N times
* {N,} - the preceding item is matched N or more times
* ., ?, *, +, ^, $, [a-d], [0-9]
