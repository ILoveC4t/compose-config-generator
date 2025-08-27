set -e

IMAGE_NAME="config-generator"
TAG="latest"

echo "Building config-generator image..."

docker build -t "${IMAGE_NAME}:${TAG}" .

echo "Successfully built ${IMAGE_NAME}:${TAG}"

if [ -n "$1" ]; then
    docker tag "${IMAGE_NAME}:${TAG}" "${IMAGE_NAME}:$1"
    echo "Tagged as ${IMAGE_NAME}:$1"
fi

echo ""
echo "Available images:"
docker images config-generator

echo ""
echo "Usage examples:"
echo "  docker run --rm -v ./templates:/templates:ro -v output:/output ${IMAGE_NAME}:${TAG}"
echo "  Use in docker-compose.yml with 'image: ${IMAGE_NAME}:${TAG}'"