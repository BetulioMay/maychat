"use client";

import {
  DetailedHTMLProps,
  ButtonHTMLAttributes,
  MouseEventHandler,
} from "react";

// interface ButtonProps {
//   text: string;
// }
// export default function Button({ text }: ButtonProps) {
//   return (
//     <button
//       className="h-full w-full rounded-md"
//       onClick={() => console.log("hello")}
//       type="submit"
//     >
//       <span className="font-bold text-white">{text}</span>
//     </button>
//   );
// }

interface ButtonProps {
  value: string;
  handleClick: MouseEventHandler<HTMLButtonElement> | undefined;
}

export default function Button({
  value,
  handleClick,
  ...props
}: ButtonProps &
  DetailedHTMLProps<
    ButtonHTMLAttributes<HTMLButtonElement>,
    HTMLButtonElement
  >) {
  return (
    <>
      <button onClick={handleClick} {...props}>
        {value}
      </button>
    </>
  );
}
