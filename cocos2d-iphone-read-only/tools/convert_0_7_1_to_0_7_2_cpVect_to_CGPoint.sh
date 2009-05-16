#!/bin/sh

# issue #
for i in `find . -name \*.[hm]`
do
sed -e 's/cpFloat/CGFloat/g' $i >$i.new
mv $i.new $i
done

# issue #
for i in `find . -name \*.[hm]`
do
sed -e 's/cpVect/CGPoint/g' $i >$i.new
mv $i.new $i
done

# issue #
for i in `find . -name \*.[hm]`
do
sed -e 's/cpv(/ccp(/g' $i >$i.new
mv $i.new $i
done

# issue #
for i in `find . -name \*.[hm]`
do
sed -e 's/cpvmult/ccpMult/g' $i >$i.new
mv $i.new $i
done

# issue #
for i in `find . -name \*.[hm]`
do
sed -e 's/cpvadd/ccpAdd/g' $i >$i.new
mv $i.new $i
done

# issue #
for i in `find . -name \*.[hm]`
do
sed -e 's/cpvsub/ccpSub/g' $i >$i.new
mv $i.new $i
done

# issue #
for i in `find . -name \*.[hm]`
do
sed -e 's/cpvzero/CGPointZero/g' $i >$i.new
mv $i.new $i
done
