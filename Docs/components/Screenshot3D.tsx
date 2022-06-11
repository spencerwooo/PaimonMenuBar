import Image from 'next/image'
import Atropos from 'atropos/react'
import screenshot from '../images/screenshot-transparent-light.png'

const Screenshot3D = () => (
  <Atropos className="w-[360px] h-[592.8]" shadow={false} highlight={false}>
    <Image
      src={screenshot}
      alt="PaimonMenuBar screenshot"
      width={360}
      height={592.8}
    />
  </Atropos>
)

export default Screenshot3D
