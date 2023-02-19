import React from "react";
import Link from "next/link";

interface TextLinkProps {
  href: string;
  value: string;
}

const TextLink: React.FC<TextLinkProps> = ({ href, value }) => {
  return (
    <>
      <Link href={href}>
        <span className="font-semibold text-purple-600 hover:underline dark:text-blue-400">
          {value}
        </span>
      </Link>
    </>
  );
};

export default TextLink;
