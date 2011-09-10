function usage {
  echo usage: $0 PROJ_NAME
}
if [ "$1" == "" ]; then
  usage;
  exit 0;
fi
proj_name=$1
template=template

# append to targets.mk
echo " $proj_name \\" >> targets.mk

# add include line to target_rules.mk
echo "include $proj_name.mk" >> target_rules.mk

# create target rules mk
echo "s/$template/$proj_name/g" > make-proj.sed
cat $template.mk | sed -f make-proj.sed > $proj_name.mk

# create init source file
cat $template.c | sed -f make-proj.sed > $proj_name.c


