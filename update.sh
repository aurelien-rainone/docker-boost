#!/usr/bin/env bash
set -Eeuo pipefail

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )

# see http://stackoverflow.com/a/2705678/433558
sed_escape_lhs() {
	echo "$@" | sed -e 's/[]\/$*.^|[]/\\&/g'
}
sed_escape_rhs() {
	echo "$@" | sed -e 's/[\/&]/\\&/g' | sed -e ':a;N;$!ba;s/\n/\\n/g'
}

alpine_versions=(3.4 3.5 3.6 3.7)

for version in "${versions[@]}"; do
    echo "Generating Dockerfiles for Boost version ${version}."
    boost_dir=boost_${version//./_}
    template=alpine
    echo "Generating templates for ${template}"

    for alpine_version in ${alpine_versions[@]}; do
	mkdir -p $version/$template/$alpine_version
        
	sed -r \
	    -e 's!%%TAG%%!'"$alpine_version"'!g' \
	    -e 's!%%BOOST_VERSION%%!'"$version"'!g' \
	    -e 's!%%BOOST_DIR%%!'"$boost_dir"'!g' \
            "Dockerfile-${template}.template" > "$version/$template/$alpine_version/Dockerfile"
	echo "Generated ${version}/${template}/${alpine_version}/Dockerfile"
    done
done
