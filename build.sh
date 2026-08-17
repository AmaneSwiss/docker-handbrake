#!/usr/bin/env bash
# Local convenience script to build the Docker image and push to Docker Hub.
# All arguments are forwarded directly to docker build.

cd "$(dirname "${0}")"

REPO=amaneswiss/handbrake

if [ -n "${1}" ]; then
    TAG="${1}"
    shift
else
    TAG="latest"
fi

# Check shell scripts in the current directory and ensure executable permissions
find . -type f | while IFS= read -r file; do
    path="${file%/*}"
    filename="${file##*/}"
    file_ext="${filename##*.}"
    file_base="${filename%.*}"
    [ "${file_ext}" = "${filename}" ] && file_ext=""
    if grep -qE '^#!.*(bash|sh)($|[[:space:]])' "${file}" || \
        grep -qE '^#!.*(python3?)($|[[:space:]])' "${file}" || \
        [ "${file_ext}" = "sh" ] || \
        [ "${file_ext}" = "py" ] || \
        [ "${file_base}" = "run" ] || \
        [ "${file_base}" = "disabled" ] || \
        [ "${file_base}" = "respawn" ] || \
        [ "${file_base}" = "finish" ]; then
        [ ! -x "${file}" ] && chmod '+x' "${file}"
    else
        [ -x "${file}" ] && chmod '-x' "${file}"
    fi
done

# Build the Docker image with the specified arguments, tag it, and use cache if available
docker build --tag "${REPO}:${TAG}" \
    --load . \
    --file "Dockerfile" \
    --build-arg BUILDKIT_INLINE_CACHE=1

# Push the image to Docker Hub if the build was successful and the user is logged in
if [ $? -eq 0 ]; then
    if docker info | grep -q 'Username:'; then
        echo -e "\n\e[32m => SUCCESS… \e[94mPush develop tag…\e[0m\n"
        docker tag "${REPO}:${TAG}" "${REPO}:develop" || exit 1
        docker push "${REPO}:develop" || exit 1
        echo -ne "\n\e[32m => SUCCESS…\e[0m\n\n\e[95mPush to Docker Hub? (y/n):\e[0m "
        read confirm
        if [[ "${confirm}" =~ ^[JjYy]$ ]]; then
            docker push "${REPO}:${TAG}"
        fi
    else
        echo -e "\n\e[33m => WARN Build successful, but you are not logged in to Docker Hub. Skipping push.\e[0m"
    fi
else
    echo -e "\n\e[31m => ERROR Build failed!\e[0m"
fi
