#!/usr/bin/env bash

# Generates docker images tags for the docker/build-push-action@v2 action depending on the branch/tag.

declare -a IMAGE_TAGS

# feature/* => sha-xxxxxxx
# Note: disabled
#if [[ "${GITHUB_REF}" =~ "refs/heads/feature/" ]]; then
#	GIT_SHA7=$(echo ${GITHUB_SHA} | cut -c1-7) # Short SHA (7 characters)
#	IMAGE_TAGS+=("${IMAGE}:sha-${GIT_SHA7}-${VERSION}")
#	IMAGE_TAGS+=("ghcr.io/${IMAGE}:sha-${GIT_SHA7}-${VERSION}")
#fi

# develop => edge
if [[ "${GITHUB_REF}" == "refs/heads/develop" ]]; then
	IMAGE_TAGS+=("${IMAGE}:edge-${VERSION}")
	IMAGE_TAGS+=("ghcr.io/${IMAGE}:edge-${VERSION}")
fi

# master => stable
if [[ "${GITHUB_REF}" == "refs/heads/master" ]]; then
	IMAGE_TAGS+=("${IMAGE}:stable-${VERSION}")
	IMAGE_TAGS+=("ghcr.io/${IMAGE}:stable-${VERSION}")
fi

# tags/v1.0.0 => 1.0
if [[ "${GITHUB_REF}" =~ "refs/tags/" ]]; then
	# Extract version parts from release tag
	IFS='.' read -a ver_arr <<< "${GITHUB_REF#refs/tags/}"
	VERSION_MAJOR=${ver_arr[0]#v*}  # 2.7.0 => "2"
	VERSION_MINOR=${ver_arr[1]}  # "2.7.0" => "7"
	IMAGE_TAGS+=("${IMAGE}:stable-${VERSION}")
	IMAGE_TAGS+=("${IMAGE}:${VERSION_MAJOR}-${VERSION}")
	IMAGE_TAGS+=("${IMAGE}:${VERSION_MAJOR}.${VERSION_MINOR}-${VERSION}")
	IMAGE_TAGS+=("ghcr.io/${IMAGE}:stable-${VERSION}")
	IMAGE_TAGS+=("ghcr.io/${IMAGE}:${VERSION_MAJOR}-${VERSION}")
	IMAGE_TAGS+=("ghcr.io/${IMAGE}:${VERSION_MAJOR}.${VERSION_MINOR}-${VERSION}")
fi

# Output a comma concatenated list of image tags
IMAGE_TAGS_STR=$(IFS=,; echo "${IMAGE_TAGS[*]}")
echo "${IMAGE_TAGS_STR}"
echo "::set-output name=tags::${IMAGE_TAGS_STR}"
