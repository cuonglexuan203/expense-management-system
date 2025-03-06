from fastapi import APIRouter


router = APIRouter()


@router.get("/")
def Test():
    return {"count": 1}
