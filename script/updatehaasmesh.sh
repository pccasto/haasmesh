# use GIT_* from configuration
source config.sh

cd /root;

# problems with installing git on LUMA devices - symbols not found...
if opkg list-installed | grep -q git-http; then
cd haasmesh
git pull
cd -

else

if opkg list-installed | grep -q unzip; then
echo "got zip"
else
opkg update > /dev/null
opkg install unzip
opkg install wget
fi

wget -q --no-check-certificate https://github.com/${GIT_USER}/haasmesh/archive/${GIT_BRANCH}.zip;
unzip ${GIT_BRANCH}.zip > /dev/null ;
rm -rf haasmesh
mv haasmesh-${GIT_BRANCH} haasmesh
rm ${GIT_BRANCH}.zip

fi

haasmesh/script/setupnode.sh

cd -
