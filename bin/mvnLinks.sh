# Create a Kuali revision specific duplicate of the maven repository out of symlinks.
#
# Existing directories:
# m2
# m2/repository
# m2/kuali
# m2/kuali/1111
# m2/kuali/1112
#
# Symlinks created:
# m2/1111/org/kuali -> m2/kuali/1111/org/kuali
# m2/1111/org -> m2/repository/org/
# m2/1111 -> m2/repository

# mvn default of REPO_HOME would be ~/.m2
export REPO_HOME=/java/m2

# mvn default of REPO_HOME would be ~/.m2/repository
export REPO_DIR=$REPO_HOME/r

# where the mvn REPO_DIR/org/kuali deliverables have been copied
export KUALI_REPO=$REPO_HOME/k

if [ "$1" = "" ]
then
	echo "Usage: $0 <kuali svn revision number to create repository maven links for>"
	exit 1
fi
echo "Creating mvn Links for $1"

if [ ! -e $KUALI_REPO ]
then
    echo "$KUALI_REPO doesn't exist skipping mvnLinks.sh"
fi

export KVERSION=$1

# recreate linked mvn repository for the passed in version
rm -rf $REPO_HOME/$KVERSION
mkdir -p $REPO_HOME/$KVERSION
mkdir -p $KUALI_REPO
for dir in $REPO_DIR/*
do
  export DIR_BASE=`basename $dir`
  echo "ln -s $REPO_DIR/$DIR_BASE $REPO_HOME/$KVERSION/$DIR_BASE"
  ln -s $REPO_DIR/$DIR_BASE $REPO_HOME/$KVERSION/$DIR_BASE  
done

# create linked mvn org directory so we can control the kuali dir
echo "Creating mvn org Links for $KVERSION"
rm -rf $REPO_HOME/$KVERSION/org
mkdir $REPO_HOME/$KVERSION/org
for file in $REPO_DIR/org/*
do
  export FILE_BASE=`basename $file`
  echo "ln -s $REPO_DIR/org/$FILE_BASE $REPO_HOME/$KVERSION/org/$FILE_BASE"
  ln -s $REPO_DIR/org/$FILE_BASE $REPO_HOME/$KVERSION/org/$FILE_BASE 
done

# create a link for the kuali directory 
rm -rf $REPO_HOME/$KVERSION/org/kuali
ln -s $KUALI_REPO/$KVERSION $REPO_HOME/$KVERSION/org/kuali  
